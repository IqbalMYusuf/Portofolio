# Import the required library
import pandas as pd
pd.set_option('display.max_columns', None)

import numpy as np

df = pd.read_csv('Covid2019_total.csv')
df = df.sort_values(by=['location','date']) # To make sure that the dataframe is sorted by location and date

# Create list of country for looping
country = df['location'].unique().tolist()

# Looping to fill the null values by using ffill
cleaned_df = pd.DataFrame(columns=df.columns)
for loc in country:
    temp_df = df.loc[df['location'] == loc]
    temp_df.ffill(inplace=True)
    temp_df.fillna(0, inplace=True) # In case if the first rows value is null
    # Fix if there is an error in data (total value in current day is lower than yesterday value)
    for col in ['total_cases', 'total_deaths', 'total_tests', 'total_vaccinations']:
        list_val = temp_df[col].tolist()
        temp_list = []
        i = 0
        while i <= (len(list_val)-1):
            if i != 0:
                if list_val[i] <= list_val[i-1]:
                    a = list_val[i-1]
                else:
                    a = list_val[i]
            else:
                a = list_val[i]

            temp_list.append(a)
            i+=1
        temp_df[col] = temp_list
    cleaned_df = pd.concat([cleaned_df, temp_df])

# Calculating percentage of infected, death, vaccination, tested and positivity rate
with np.errstate(divide='ignore', invalid='ignore'): #To ignore error that resulted from 0 / 0 division
    cleaned_df['PercentageInfected'] = np.divide(cleaned_df['total_cases'].astype(int), cleaned_df['population'].astype(int)) * 100
    cleaned_df['DeathsPercentage'] = np.divide(cleaned_df['total_deaths'].astype(int), cleaned_df['total_cases'].astype(int)) * 100
    cleaned_df['PercentageTested'] = np.divide(cleaned_df['total_tests'].astype(int), cleaned_df['population'].astype(int)) * 100
    cleaned_df['PositivityRate'] = np.divide(cleaned_df['total_cases'].astype(int), cleaned_df['total_tests'].astype(int)) * 100
    cleaned_df['PercentageVaccinated'] = np.divide(cleaned_df['total_vaccinations'].astype(int), cleaned_df['population'].astype(int)) * 100

cleaned_df.replace([np.nan, np.inf, -np.inf], 0, inplace=True)
cleaned_df.to_csv('Covid2019_total_cleaned.csv')
