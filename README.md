# Default Forecasting Classification Model for Fintech
*Marcos Oliveira (mvoassis@gmail.com)*

## Description

This project is part of Alura Challenges, where a set of analysis and Machine Learning models are applied to "Alura Cash," a fictional Fintech. 

The objective is to help their decision-making process for credit granting. After a meeting with the company's staff, they delivered a database with client and loan information, which should be analyzed, treated, and used to generate a classification model to identify potential defaulting clients. 

> Project developed using: MySQL, Python, Jupyter notebook (Google Colab), Pandas, Scikit Learn, Numpy, Matplotlib, Seaborn, FastAPI, Uvicorn, and PowerBI. 

## Quick Access

* [Exploratory Data Analysis - EDA (Notebook)](https://github.com/mvoassis/default_forecasting_fintech/blob/main/notebooks/EDA_Fintech_Default_detection.ipynb).
* [Classification Model Development (Notebook)](https://github.com/mvoassis/default_forecasting_fintech/blob/main/notebooks/Model_Fintech_Default_Classification.ipynb)
* [Model API](https://github.com/mvoassis/default_forecasting_fintech/blob/main/Dafaulting_classifier_API.py)
* [PowerBI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiOWNkOWM2ZjctYTMxYS00MWUxLThlMjQtNmZkZjNlNWI3MWQ4IiwidCI6ImMzN2IzN2EzLWU5ZTItNDJmOS1iYzY3LTRiOWI3MzhlMWRmMCJ9)

## Files

* sql_dumps folder -> MySQL Dump Files to reconstruct the database.
* SQL data treatment.sql -> SQL commands to treat database data and create a unified information table. (Uncomment "DELETE" lines if you wish to perform a null/empty cleaning inside the database. In this implementation, this step was left for treatment using Python).
* dados_unificados.csv -> Output of the SQL data treatment.sql file, exported to .csv. 
* unified_data_not_null.csv -> The same as "dados_unificados.csv," but dropping nulls. 
* clean_data_{13f, full}.csv -> Preprocessed data, ready for usage by the classification model (13f - 13 features, full - all features). The number of features is discussed in the EDA notebook (notebooks/EDA_Fintech_Default_detection.ipynb ) 
* notebooks/EDA_Fintech_Default_detection.ipynb - Exploratory data analysis and data preparation notebook (Google Colab)
* notebooks/Model_Fintech_Default_Classification.ipynb - Adjustment of data and testing environments, as well as the proposition of a classification model for detecting defaulting clients.
* Dafaulting_classifier_API.py - Python file where the proposed model is implemented as an API using FastAPI and uvicorn.
* Results_Dashboard.pbix - Power BI project implementing the project's resulting Dashboard.

## Steps

### 1 - SQL data treatment

The data were made available in SQL dump format, in a dataset composed of 4 tables (dumps available at the sql_dumps folder):

* dados_mutuarios - Loan client data;
* emprestimos - Loan information;
* historicos_banco - Bank information;
* ids - Table relating the ids of the 3 other tables. 

Data were initially treated by:

1. Removing registries with null ids;
2. Generating a single table relating all data available. (SQL data treatment.sql )
3. Exporting the resulting table to .csv format for further analysis using Python (dados_unificados.csv)


### 2 - Exploratory Data Analysis (EDA)

The exported .csv file was loaded, initially treated, and analyzed through an EDA available at "notebooks/EDA_Fintech_Default_detection.ipynb".

Among the loaded information, the following verifications and adjustments were performed: 

* Checking for NULL values within the columns: 
  1. Check the number of null values of each feature
  2. Check each quantitative feature's distribution
  3. Check if it is possible to fill in null values
  4. Drop lines with null information when it is not possible to fill.
* Checking Target Column - To define whether the data is balanced. 
* Checking for data Outliers
  1. Boxplot of quantitative features
  2. Individual Analysis
  3. Plot boxplot again for comparison
* Treatment of Categorical data - Applying one-hot encoding on the categorical data features.
* Correlation Analysis
  1. Evaluate the correlation between features and target
  2. Evaluate the correlation between dependent variables

### 3 - Classification Model Development

Further data treatment and the classification model's development are available at "notebooks/Model_Fintech_Default_Classification.ipynb".

The detection approach was tested with the two .csv files generated in the previous step, using the 13 most visually relevant features (clean_data_13f.csv) and all data features (data_cleal_full.csv). 

> Best outcomes were achieved with all data features, so this database was used on the rest of the notebook. 

Different steps were performed toward the implementation of the proposed method, which was:

* ***Separating a validation dataset*** - Before starting the classification model, the data should be balanced, normalized, and divided into Training, Testing, and Validation sets. The validation set should be saved before the balancing process, which should be applied only to the training data.
* ***Balancing training data*** - Three approaches could be tested for data balancing:
  1. Upsampling - Resampling minority class, replicating rows to the size of the majority class. (Could lead to overfitting)
  2. Downsampling - Resampling the majority class, replicating rows to the size of the minority class. (Could lead to underfitting)
  3. Hybrid approach - A mixture of approaches 1 and 2.
  > As upsampling achieved better classification outcomes, it was the chosen approach for the proposed method. 
* ***Normalizing data*** - To improve the performance of ML methods, I've normalized the data using Standard Scaler.
* ***Train / Test Split*** - Separated data into train and test sets in a shuffled, stratified way. 30% of this data was saved for testing (part of the initial dataset is already reserved for validation).
* ***Models' implementation and testing*** - 6 different methods were evaluated regarding the efficiency of correctly classifying defaulting clients, which were:
  1. Decision Tree (DT)
  2. Random Forest (RF)
  3. Deep Neural Network (DNN)
  4. Hist Gradient Boosting (HGB)
  5. Bagging Classification
  6. Voting Classification (RF+HGB+Bagging)
  > After the training, the methods were tested with ROC Curve, Confusion Matrix, and classification metrics (accuracy, precision, recall, f-score).
* ***Evaluating methods with validation Data*** - Finally, the trained methods were applied to the validation dataset.
  * Voting Classification achieved the best outcomes, on average. 
  * However, as it uses the classification of 3 other methods, it was slower than all the other methods.
* ***Hyperparameter Optimization*** - Since the Voting method achieved better outcomes, I've applied a Randomized Search to improve the results of RF, HGB, and Bagging methods even more.
  * By comparing the optimized Voting method with the initial one, it was possible to verify a performance improvement in all tested metrics (ROC Curve, Confusion Matrix, and Classification metrics).
* ***Methods' saving*** - The methods were saved using pickle for future API implementation. 

### 4 - API implementation

The proposed classification method (voting) for defaulting clients, the one-hot encoding, and the standard scaling processes were saved in pickle files.

These files were used to implement an API using ***Python***, ***FastAPI***, and ***uvicorn***. The code is available at [Dafaulting_classifier_API.py](https://github.com/mvoassis/default_forecasting_fintech/blob/main/Dafaulting_classifier_API.py)

> The API was locally implemented. 


### 5 - PowerBI Visualization (Dashboard)

Finally, I've developed a PowerBI Dashboard for visualizing the results of the project. It is linked to the REST API to enable dynamic client evaluation through the input variables (features). 

The Dashboard is divided into 2 parts:
  1. Client Status (defaulting or non-defaulting client) and Defaulting probability (accordingly to the proposed method).
  2. Dataset visualizations

In the second part (Dataset visualizations), it is possible to overview some characteristics of the dataset used in this project, such as:
  * Defaulting status per credit class;
  * Defaulting status per Home ownership status;
  * Defaulting status per loan objective;
  * Defaulting status per age.

The file of the project is available at [Results_Dashboard.pbix](https://github.com/mvoassis/default_forecasting_fintech/blob/main/Results_Dashboard.pbix)

The Dashboard was published online and is available [here](https://app.powerbi.com/view?r=eyJrIjoiOWNkOWM2ZjctYTMxYS00MWUxLThlMjQtNmZkZjNlNWI3MWQ4IiwidCI6ImMzN2IzN2EzLWU5ZTItNDJmOS1iYzY3LTRiOWI3MzhlMWRmMCJ9)
  > It is not possible to change the input data since the classification model API was locally implemented. However, it is possible to interact with the remaining dashboard information.
