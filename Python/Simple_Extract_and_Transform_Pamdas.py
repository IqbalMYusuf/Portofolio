# Importing the required library for this project
import pandas as pd
pd.set_option('display.max_columns', None)
import numpy as np

# Extracting data from source CSV
df_participant = pd.read_csv('https://storage.googleapis.com/dqlab-dataset/dqthon-participants.csv')

# Creating new columns 'postal_code' by extracting the postal code from address columns value
df_participant['postal_code'] = df_participant['address'].str.extract(r'([0-9]+$)')

# Creating new columns 'city' by extracting the city from address columns value
df_participant['city'] = df_participant['address'].str.extract(r'(?<=\n)(\w.+)(?=,)')

# Creating new_columns called as github_profile for every participant
df_participant['github_profile'] = 'https://github.com/' + df_participant['first_name'].str.lower() + df_participant['last_name'].str.lower()

# Cleaning phone number columns
df_participant['cleaned_phone_number'] = df_participant['phone_number'].str.replace(r'(\+?62)', '0')
df_participant['cleaned_phone_number'] = df_participant['cleaned_phone_number'].str.replace(r'(\W)', '')

# Creating team column with format abbreviated_first&last_name-country-abbreviated_institute_name
def abbrv(col):
    abbrv_name = '%s%s'%(col['first_name'][0], col['last_name'][0])
    country = col['country']
    lst = col['institute'].split()
    abbrv_inst = ''
    for word in lst:
        abbrv_inst += word[0]
    return '%s-%s-%s'%(abbrv_name, country, abbrv_inst)
df_participant['team_name'] = df_participant.apply(abbrv, axis=1)

''' Creating E-mail column
E-mail format:
xxyy@aa.bb.[ac/com].[cc]

Notes:
xx -> first_name in lowercase
yy -> last_name in lowercase
aa -> institution name

bb and cc values follow aa value. Rules:
- In the Institution is a University, so
  bb -> concatenation of every first word from University name in lowercase
  then, followed by .ac which indicates education institute, and followed by pattern cc
- If Institution isn't University, so
  bb -> concatenation of every first word from University name in lowercase then, followed by .com

cc -> participant's country of origin, Rules:
- If the number of the word inside a country name is more than 1, concatenate every first word from the country name in lowercase
- If the country name only contains 1 word, take the first three word of that country's name in lowercase
'''
def email(col):
    xxyy = col['first_name'].lower() + col['last_name'].lower()
    if 'Universitas' in col['institute']:
        lst = col['institute'].lower().split()
        abbrv_inst = ''
        for word in lst:
            abbrv_inst += word[0]
        bb = '%s.ac'%(abbrv_inst)
        if len(col['country'].split()) > 1:
            lst = col['country'].lower().split()
            abbrv_count = ''
            for word in lst:
                abbrv_count += word[0]
            return '%s@%s.%s'%(xxyy, bb, abbrv_count)
        else:
            count = col['country'][:3].lower()
            return '%s@%s.%s'%(xxyy, bb, count)
    else:
        lst = col['institute'].lower().split()
        abbrv_inst = ''
        for word in lst:
            abbrv_inst += word[0]
        return '%s@%s.com'%(xxyy, abbrv_inst)
df_participant['E-mail'] = df_participant.apply(email, axis=1)

# Change birth_date and register_time column formatting
df_participant['birth_date'] = pd.to_datetime(df_participant['birth_date'], format='%d\n%b\n%Y')
df_participant['register_at'] = pd.to_datetime(df_participant['register_time'], unit='s')

print(df_participant.head())
