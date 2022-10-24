# Default Forecasting Classification Model for Fintech
*Marcos Oliveira (mvoassis@gmail.com)*

## Description

This project is part of Alura Challenges, where a set of analysis and Machine Learning models are applied to "Alura Cash", a fictional Fintech. 

The objective is to help their decision making process for credit granting. After a meeting with the company's staff, they delivered a database with client and loan information, which should be analyzed, treated, and used on the generation of a classification model to identify potential defaulting clients. 

## Files

* sql_dumps folder -> MySQL Dump Files to reconstruct the database.
* SQL data treatment.sql -> SQL commands to treat database data and create a unified information table. (Uncomment "DELETE" lines if you wish to perform a null/empty cleaning inside the database. In this implementation, this step was left for treatment using python).
* dados_unificados.csv -> Output of the SQL data treatment.sql file, exported to .csv. 
* unified_data_not_null.csv -> The same as "dados_unificados.csv", but dropping nulls. 
* clean_data_{10f, 13f, full}.csv -> Preprocessed data, ready for usage by the classification model (10f - 10 features, 13f - 13 features, full - all features). The number of features is discussed in the EDA notebook (notebooks/EDA_Fintech_Default_detection.ipynb ) 
* notebooks/EDA_Fintech_Default_detection.ipynb - Exploratory data analysis and data preparation notebook (Google Colab)
* notebooks/Model_Fintech_Default_Classification.ipynb - Adjustment of data and testing environments, as well as the proposition of a classification model for detecting defaulting clients.

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

The .csv exported file was loaded, initially treated and analysed through an EDA available at "notebooks/EDA_Fintech_Default_detection.ipynb".

Among the loaded information, the following verifications and adjustments were performed: 

* Checking for NULL values within the columns: 
  1. Check the amount of null values of each feature
  2. Check each quantitative feature's distribution
  3. Check if it is possible to fill null values
  4. Drop lines with null information when it is not possible to fill.
* Checking Target Column - To define wether the data is balanced or not. 
* Checking for data Outliers
  1. Boxplot of quantitative features
  2. Individual Analysis
  3. Plot boxplot again for comparison
* Treatment of Categorical data - Applying one-hot encoding on the categorical data features.
* Correlation Analysis
  1. Evaluate correlation between features and target
  2. Evaluate correlation between dependent variables



