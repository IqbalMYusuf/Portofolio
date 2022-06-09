-- Shows all the data from CovidDeath table
SELECT * FROM Portofolio.CovidDeath

-- Shows unique value for continent and location columns
SELECT DISTINCT continent FROM Portofolio.CovidDeath
SELECT DISTINCT location  FROM Portofolio.CovidDeath WHERE continent IS NOT NULL 
SELECT DISTINCT location  FROM Portofolio.CovidDeath WHERE continent IS NULL 


-- Shows total cases and total deaths per location
SELECT location, date, population, total_cases, total_deaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
-- null values in continent resulted in location column contain continent name and categorization by income
-- the following columns will contain the total values for that continent, not the location 

-- Shows total cases and total deaths
-- total per location
SELECT location, MAX(population), MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location

-- total per continent
-- If using the continent column without null value
SELECT continent, MAX(population), MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY continent 

-- If using the continent column with null value
SELECT location, MAX(population), MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location
-- It shows that location rows with continent name contain total for that continent

-- Location section
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, date, population, total_cases, new_cases, (total_cases/population)*100 AS PercentageInfected, total_deaths, new_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, t.totalPopulation, t.totalCases, (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, t.totalDeaths, (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
(SELECT location,  MAX(population) AS totalPopulation, MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
(SELECT location, date, population, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, new_deaths, SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World'))
SELECT location, date, new_cases, cumNewCases, (cumNewCases/population)*100 AS PercentageInfected, cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage FROM cumValues


-- Continent section
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, date, population, total_cases, new_cases, (total_cases/population)*100 AS PercentageInfected, total_deaths, new_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, t.totalPopulation, t.totalCases, (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, t.totalDeaths, (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
(SELECT location,  MAX(population) AS totalPopulation, MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
(SELECT location, date, population, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, new_deaths, SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World'))
SELECT location, date, new_cases, cumNewCases, (cumNewCases/population)*100 AS PercentageInfected, cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage FROM cumValues


-- Categorization by country income
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, date, population, total_cases, new_cases, (total_cases/population)*100 AS PercentageInfected, total_deaths, new_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, t.totalPopulation, t.totalCases, (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, t.totalDeaths, (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
(SELECT location,  MAX(population) AS totalPopulation, MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income')
GROUP BY location) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
(SELECT location, date, population, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, new_deaths, SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income'))
SELECT location, date, new_cases, cumNewCases, (cumNewCases/population)*100 AS PercentageInfected, cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage FROM cumValues


-- Global values
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, date, population, total_cases, new_cases, (total_cases/population)*100 AS PercentageInfected, total_deaths, new_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location = 'World'
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, t.totalPopulation, t.totalCases, (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, t.totalDeaths, (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
(SELECT location,  MAX(population) AS totalPopulation, MAX(total_cases) AS totalCases, MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location = 'World'
GROUP BY location) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
(SELECT location, date, population, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, new_deaths, SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location = 'World')
SELECT location, date, new_cases, cumNewCases, (cumNewCases/population)*100 AS PercentageInfected, cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage FROM cumValues

