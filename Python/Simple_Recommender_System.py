'''
In this project, we will create simple recommender system by using weighted rating from IMDB
Data that used in this project were provided by DQLab.id
'''

# Import the required library
import pandas as pd
pd.set_option('display.max_columns', None)
import numpy as np

# Unload the required data and shows the top 5 data
movie_df = pd.read_csv('https://storage.googleapis.com/dqlab-dataset/title.basics.tsv', sep='\t')
rating_df = pd.read_csv('https://storage.googleapis.com/dqlab-dataset/title.ratings.tsv', sep='\t')

'''print(movie_df.head())
print(rating_df.head())'''

''' # Check section
# Checking data types in both dataframe
print(movie_df.info())
print(rating_df.info())

# Checking the amount of null values existed in both dataframe
print(movie_df.isnull().sum()) # there is null value on this dataframe
print(rating_df.isnull().sum()) # There is no null value in rating_df

# Checking the occurence of null value in movie_df
print(movie_df.loc[movie_df['primaryTitle'].isnull() | movie_df['originalTitle'].isnull()])
print(movie_df.loc[movie_df['genres'].isnull()])'''
# title, genres, startYear, and runtimeMinutes are needed, so we need to drop null value from those columns
movie_df.dropna(inplace=True)

''' # Check section
# Check unique value for every columns
for i in movie_df.columns:
    print (i)
    print(movie_df[i].unique())
# It can be seen that null values in startYear, endYear, and runtimeMinutes column is represented by \\N, so we must changes \\N to null/nan values and change datatypes into float64
for i in ['startYear', 'endYear', 'runtimeMinutes']:
    movie_df[i] = movie_df[i].replace('\\N', np.nan).astype('float64')

# Check the results
for i in ['startYear', 'endYear', 'runtimeMinutes']:
    print (i)
    print(movie_df[i].unique())
'''

# Change genre column values into lists
def to_lists(x):
    if len(x) > 1:                  # Only selecting rows with values
        if ',' in x:                # For rows with more than one genre
            return x.split(',')
        else:                       # For columns with one genre
            return x.split()
    else:                           # Return empty list for empty columns
        return []

movie_df['genres'] = movie_df['genres'].apply(lambda x: to_lists(str(x)))

# Inner join between movie_df and rating_df
movie_rating_df = pd.merge(movie_df, rating_df, how='inner')

# Creating column score that contain weighted rating score from IMDB
# with formula WR=(v/(v+m))R+(m/(v+m))C

# Defining the formula for WR
def wr(col):
    # Calculating C values
    C = movie_rating_df['averageRating'].mean()

    # Calculating m, if we want films with ratings higher than 80% of population
    m = movie_rating_df['numVotes'].quantile(0.8)

    v = col['numVotes']
    R = col['averageRating']
    col['score'] = (v / (v + m))*R + (m / (v + m))*C
    return col['score']

wr(movie_rating_df)

# Creating simple recommender
def simple_recommender(df, top=100):
    df = df.loc[df['numVotes'] >= df['numVotes'].quantile(0.8)] # Only selecting rows with numVotes >= m values
    df = df[:top] # Hanya mengambil data n-teratas (nilai default 100)
    return df

df = movie_rating_df.copy()
# Creating user preference reccommender system
def user_preference_recommender(df, askAdult, askYear, askGenre, top=100):
    # Filtering data with askAdult
    if askAdult.lower() == 'yes':
        df = df.loc[df['isAdult'] == 1]
    else:
        df = df.loc[df['isAdult'] == 0]

    # Filtering data with askYear
    df = df.loc[df['startYear'] == askYear]
    
    # Filtering data with askGenre
    # Create helping column 'checkGenre'
    df['genreCheck'] = df['genres'].apply(lambda x: askGenre.capitalize() in x)
    df = df.loc[df['genreCheck'] == True]
    df.drop(['genreCheck'], axis=1, inplace=True)

    # Only takes film with number of votes >= m
    df = df.loc[df['numVotes'] >= df['numVotes'].quantile(0.8)]

    # Takes the n-th top data
    df = df.sort_values(by='score', ascending=False)
    df = df[:top]
    return df

# Creating input for users
askAdult = input('Is the film for adults? (yes/no):  ')
askYear = input('In what year the film released?: ')
askGenre = input('What is the genre of the movie?: ')

print(user_preference_recommender(df, askAdult, askYear, askGenre))



