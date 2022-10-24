from fastapi import FastAPI
import pandas as pd

def load_model(name):
    import pickle
    file = name + '.pkl'
    with open(file,'rb') as file:
        model = pickle.load(file)
    print('Model '+name+' - sklearn loaded')
    return model

def onehotencoding(data, ohe):

    feature_arr = ohe.transform(data[['person_home_ownership', 'loan_intent', 'loan_grade']]).toarray()
    feature_labels = [item for sublist in ohe.categories_ for item in sublist]

    # the above transformed_data is an array so convert it to dataframe
    encoded_data = pd.DataFrame(feature_arr, columns=feature_labels)

    # now concatenate the original data and the encoded data using pandas
    concatenated_data = pd.concat([data, encoded_data], axis=1)

    concatenated_data = concatenated_data.drop(['person_home_ownership', 'loan_intent', 'loan_grade'], axis=1)

    #cb_person_default_on_file -> binary
    no_yes = {'N': 0,
              'Y': 1}
    concatenated_data['cb_person_default_on_file'] = concatenated_data['cb_person_default_on_file'].map(no_yes)

    return concatenated_data

def drop_highly_correlated_feateures(data):
    data = data.drop('cb_person_cred_hist_length', axis=1)
    data = data.drop('Mortgage', axis=1)
    data = data.drop('A', axis=1)
    return data


app = FastAPI()
ohe = load_model('ohe')
scaler = load_model('scaler')
model = load_model('Voting_Opt')
# model = load_model('')

@app.get("/model/v1:{person_age}&v2:{person_income}&v3:{person_home_ownership}&v4:{person_emp_length}&v5:{loan_intent}&v6:{loan_grade}&v7:{loan_amnt}&v8:{loan_int_rate}&v9:{loan_percent_income}&v10:{cb_person_default_on_file}&v11:{cb_person_cred_hist_length}")
def prediction_model(person_age, person_income, person_home_ownership,person_emp_length,
                     loan_intent, loan_grade, loan_amnt, loan_int_rate, loan_percent_income,
                     cb_person_default_on_file, cb_person_cred_hist_length):

    data = {
        'person_age' : [float(person_age)],
        'person_income' : [float(person_income)],
        'person_home_ownership': [person_home_ownership],   #categ
        'person_emp_length': [float(person_emp_length)],
        'loan_intent': [loan_intent],                #categ
        'loan_grade': [loan_grade],                  #categ
        'loan_amnt': [float(loan_amnt)],
        'loan_int_rate': [float(loan_int_rate)],
        'loan_percent_income': [float(loan_percent_income)],
        'cb_person_default_on_file': [cb_person_default_on_file],    #categ / binary
        'cb_person_cred_hist_length': [float(cb_person_cred_hist_length)]
    }
    #print(data)

    data = pd.DataFrame(data)

    data = onehotencoding(data, ohe)
    data = drop_highly_correlated_feateures(data)
    data = scaler.transform(data)


    pred = model.predict(data)[0]
    proba_0 = model.predict_proba(data)[0][0]
    proba_1 = model.predict_proba(data)[0][1]
    print("Results:",pred,proba_0,proba_1)
    return {'result' : pred,
            'proba_0' : proba_0,
            'proba_1' : proba_1 }