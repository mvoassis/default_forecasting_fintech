START TRANSACTION;

# Table "historicos_banco"

# adding a NOT NULL constraint to loan_id, and converting it on the table's PK
ALTER TABLE historicos_banco MODIFY cb_id VARCHAR(16) NOT NULL;
ALTER TABLE historicos_banco
ADD CONSTRAINT PK_Cb PRIMARY KEY (cb_id);

# delete rows with nulls or empty values on historico_banco 
#DELETE FROM historicos_banco WHERE cb_person_cred_hist_length IS NULL;
#DELETE FROM historicos_banco WHERE cb_person_default_on_file = '';

# -----------------------------------------------------------------------------------------------
# Table "dados_mutuarios"

# delete rows where person_id is empty
DELETE FROM dados_mutuarios WHERE person_id= '';

# adding a NOT NULL constraint to person_id, and converting it on the table's PK
ALTER TABLE dados_mutuarios MODIFY person_id VARCHAR(16) NOT NULL;
ALTER TABLE dados_mutuarios
ADD CONSTRAINT PK_Person PRIMARY KEY (person_id);

# delete rows where person_income OR person_age is null
#DELETE FROM dados_mutuarios where (person_income IS NULL) OR (person_age IS NULL);

# delete rows where person_home_ownership is empty
#DELETE FROM dados_mutuarios WHERE person_home_ownership = '';

# delete rows where person_emp_length is null
#DELETE FROM dados_mutuarios WHERE person_emp_length IS NULL;

# -----------------------------------------------------------------------------------------------
# Table "emprestimos"

# adding a NOT NULL constraint to loan_id, and converting it on the table's PK
ALTER TABLE emprestimos MODIFY loan_id VARCHAR(16) NOT NULL;
ALTER TABLE emprestimos
ADD CONSTRAINT PK_Loan PRIMARY KEY (loan_id);

# Delete rows with null values on loan_status (target) or loan_int_rate
#DELETE FROM emprestimos WHERE (loan_status IS NULL) OR (loan_int_rate IS NULL);

# Delete rows with empty values on loan_grade or loan_intent
#DELETE FROM emprestimos WHERE (loan_grade = '') OR (loan_intent = '');

# -----------------------------------------------------------------------------------------------
# Table "ids"

# Converting the tipe Text to Varchar(16) to standarize id's
ALTER TABLE ids MODIFY person_id VARCHAR(16) NOT NULL;
ALTER TABLE ids MODIFY loan_id VARCHAR(16) NOT NULL;
ALTER TABLE ids MODIFY cb_id VARCHAR(16) NOT NULL;

# -----------------------------------------------------------------------------------------------
# Creating table "unido" based on an inner join from 'ids' with 'dados_mutuarios', 'emprestimos' and 'historicos_banco'..

CREATE TABLE unido AS
SELECT person.person_age, person.person_income, person.person_home_ownership,
person.person_emp_length, emp.loan_intent, emp.loan_grade, emp.loan_amnt, emp.loan_int_rate,
emp.loan_status, emp.loan_percent_income, bnc.cb_person_default_on_file, bnc.cb_person_cred_hist_length
FROM ids
  INNER JOIN dados_mutuarios person
  ON ids.person_id = person.person_id
  INNER JOIN emprestimos emp
  ON ids.loan_id = emp.loan_id
  INNER JOIN historicos_banco bnc
  ON ids.cb_id = bnc.cb_id;

# -----------------------------------------------------------------------------------------------
# Table 'unido'
# Correcting missing values of  'loan_percent_income' and 'loan_amnt'

UPDATE unido SET loan_percent_income = loan_amnt / person_income WHERE (loan_percent_income IS NULL) AND (loan_amnt IS NOT NULL);

UPDATE unido SET loan_amnt = loan_percent_income * person_income WHERE (loan_percent_income IS NOT NULL) AND (loan_amnt IS NULL);

#DELETE FROM UNIDO WHERE (loan_percent_income IS NULL) AND (loan_amnt IS NULL);

# -----------------------------------------------------------------------------------------------

COMMIT;