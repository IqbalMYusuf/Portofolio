-- Data exploration from table CovidDeath 
-- Shows all the data from CovidDeath table
SELECT * FROM Portofolio.CovidDeath

-- Shows unique value for continent and location columns
SELECT DISTINCT continent FROM Portofolio.CovidDeath
SELECT DISTINCT location  FROM Portofolio.CovidDeath WHERE continent IS NOT NULL 
SELECT DISTINCT location  FROM Portofolio.CovidDeath WHERE continent IS NULL 


-- Shows total cases and total deaths per location
SELECT location, 
       date, 
       population, 
       total_cases, 
       total_deaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
-- null values in continent resulted in location column contain continent name and categorization by income
-- the following columns will contain the total values for that continent, not the location 

-- Shows total cases and total deaths
-- total per location
SELECT location, 
       MAX(population), 
       MAX(total_cases) AS totalCases, 
       MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location

-- total per continent
-- If using the continent column without null value
SELECT continent, 
       MAX(population), 
       MAX(total_cases) AS totalCases, 
       MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY continent 

-- If using the continent column with null value
SELECT location, 
       MAX(population), 
       MAX(total_cases) AS totalCases, 
       MAX(total_deaths) AS totalDeaths
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location
-- It shows that location rows with continent name contain total for that continent

-- Location section
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, 
       date, 
       population, 
       total_cases, 
       new_cases, 
       (total_cases/population)*100 AS PercentageInfected, 
       total_deaths, 
       new_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, 
       t.totalPopulation, 
       t.totalCases, 
       (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
       t.totalDeaths, 
       (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
    (SELECT location,  
            MAX(population) AS totalPopulation, 
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
     FROM Portofolio.CovidDeath
    WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
    GROUP BY location
    ) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
                (SELECT location, 
                        date, 
                        population, 
                        new_cases, 
                        SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, 
                        new_deaths, 
                        SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World'))
SELECT location, 
       date, 
       new_cases, 
       cumNewCases, 
       (cumNewCases/population)*100 AS PercentageInfected, 
       cumNewDeaths, 
       (cumNewDeaths/cumNewCases) AS DeathPercentage 
FROM cumValues


-- Continent section
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, 
       date, 
       population, 
       total_cases, 
       new_cases, 
       (total_cases/population)*100 AS PercentageInfected, 
       total_deaths, 
       new_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, 
       t.totalPopulation, 
       t.totalCases, 
       (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
       t.totalDeaths, 
       (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
    (SELECT location,  
            MAX(population) AS totalPopulation, 
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
     FROM Portofolio.CovidDeath
     WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
     GROUP BY location
    ) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
                (SELECT location, 
                        date, 
                        population, 
                        new_cases, 
                        SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, 
                        new_deaths, 
                        SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World'))
SELECT location, 
       date, 
       new_cases, 
       cumNewCases, 
       (cumNewCases/population)*100 AS PercentageInfected, 
       cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage 
FROM cumValues


-- Categorization by country income
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, 
       date, 
       population, 
       total_cases, 
       new_cases, 
       (total_cases/population)*100 AS PercentageInfected, 
       total_deaths, new_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income')
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, 
       t.totalPopulation, 
       t.totalCases, 
       (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
       t.totalDeaths, (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
    (SELECT location,  
            MAX(population) AS totalPopulation, 
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
     FROM Portofolio.CovidDeath
     WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income')
     GROUP BY location
    ) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
                (SELECT location, 
                        date, population, 
                        new_cases, 
                        SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, 
                        new_deaths, 
                        SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income'))
SELECT location, 
       date, 
       new_cases, 
       cumNewCases, 
       (cumNewCases/population)*100 AS PercentageInfected, 
       cumNewDeaths, (cumNewDeaths/cumNewCases) AS DeathPercentage 
FROM cumValues


-- Global values
-- Shows daily PercentagedInfected and DeathPercentage
SELECT location, 
       date, 
       population, 
       total_cases, 
       new_cases, 
       (total_cases/population)*100 AS PercentageInfected, 
       total_deaths, new_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portofolio.CovidDeath
WHERE continent IS NULL AND location = 'World'
ORDER BY 1,2

-- Shows total PercentagedInfected and DeathPercentage
SELECT t.location, 
       t.totalPopulation, 
       t.totalCases, 
       (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
       t.totalDeaths, 
       (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
FROM 
    (SELECT location,  
            MAX(population) AS totalPopulation, 
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
     FROM Portofolio.CovidDeath
     WHERE continent IS NULL AND location = 'World'
     GROUP BY location
    ) AS t
GROUP BY t.location
ORDER BY 1

-- Shows cumulative values for new_cases and new_deaths using windows function 
WITH cumValues AS 
                (SELECT location, 
                        date, 
                        population, 
                        new_cases, 
                        SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) AS cumNewCases, 
                        new_deaths, 
                        SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS cumNewDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location = 'World')
SELECT location, 
       date, 
       new_cases, 
       cumNewCases, 
       (cumNewCases/population)*100 AS PercentageInfected, 
       cumNewDeaths, 
       (cumNewDeaths/cumNewCases) AS DeathPercentage 
FROM cumValues

-- Data exploration for table CovidVaccination 
-- Shows all data in CovidVaccination table
SELECT * FROM Portofolio.CovidVaccination

-- Location section
-- Shows vaccination and test data
SELECT location, 
       date, 
       new_tests, 
       total_tests, 
       new_vaccinations, 
       total_vaccinations 
FROM Portofolio.CovidVaccination
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')

-- Shows cumulative test and vaccination data
SELECT location, 
       date, 
       SUM(new_tests) OVER (PARTITION BY location ORDER BY location, date) AS cumTests, 
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS cumVac 
FROM Portofolio.CovidVaccination
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')

-- Shows total test and vaccination
SELECT location, 
       MAX(total_tests) AS totalTests, 
       MAX(total_vaccinations) AS totalVac, 
       SUM(new_tests) AS totalTests2, 
       SUM(new_vaccinations) AS totalVac2 
FROM Portofolio.CovidVaccination
WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
GROUP BY location 
ORDER BY 1 

-- Shows total test and vaccination
SELECT t.location,
       CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
       CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
FROM
    (SELECT location, 
            MAX(total_tests) AS m_test, 
            SUM(new_tests) AS sn_test, 
            MAX(total_vaccinations) AS m_vac, 
            SUM(new_vaccinations) AS sn_vac
     FROM Portofolio.CovidVaccination
     WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
     GROUP BY location 
     ORDER BY 1
    ) AS t 


-- Continent section
-- Shows vaccination and test data per continent
SELECT location, 
       date, 
       new_tests, 
       total_tests, 
       new_vaccinations
FROM Portofolio.CovidVaccination
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')


-- Shows cumulative test and vaccination per continent
SELECT location, 
       date, 
       SUM(new_tests) OVER (PARTITION BY location ORDER BY location, date) AS cumTests, 
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS cumVac 
FROM Portofolio.CovidVaccination
WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')


-- Shows cumulative test and vaccination by country income
SELECT location, 
       date, 
       SUM(new_tests) OVER (PARTITION BY location ORDER BY location, date) AS cumTests, 
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS cumVac 
FROM Portofolio.CovidVaccination
WHERE continent IS NULL AND location IN ('High income','Low income','Lower middle income','Upper middle income')


-- Shows global cumulative test and vaccination
SELECT location, 
       date, 
       SUM(new_tests) OVER (PARTITION BY location ORDER BY location, date) AS cumTests, 
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS cumVac 
FROM Portofolio.CovidVaccination
WHERE continent IS NULL AND location = 'World'

-- Data exploration on join table between CovidDeath and CovidVaccination
-- Location section
-- Join table total percentageInfected and DeathPercentage with total test and vaccination for every location
WITH t1 AS
(SELECT t.location, 
        t.totalPopulation, 
        t.totalCases, 
        (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
        t.totalDeaths, 
        (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
 FROM 
    (SELECT location,  
            MAX(population) AS totalPopulation,
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
    FROM Portofolio.CovidDeath
    WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
    GROUP BY location) AS t
GROUP BY t.location)

SELECT t1.location, 
       t1.totalPopulation, 
       t2.totalTest, 
       t1.totalCases, 
       t2.totalVac, 
       t1.totalDeaths, 
       (t2.totalTest/t1.totalPopulation)*100 AS PercentageTested, 
       (t1.totalCases/t2.totalTest)*100 AS PositivityRate, 
       t1.totalPercentageInfected, 
       (t2.totalVac/t1.totalPopulation)*100 AS PercentageVaccinated, 
       t1.totalDeathPercentage
FROM t1 
JOIN 
    (SELECT t.location,
            CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
            CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
     FROM
        (SELECT location, 
                MAX(total_tests) AS m_test, 
                SUM(new_tests) AS sn_test, 
                MAX(total_vaccinations) AS m_vac, 
                SUM(new_vaccinations) AS sn_vac
         FROM Portofolio.CovidVaccination
        WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
        GROUP BY location 
        ORDER BY 1) AS t 
    ) AS t2 
ON t1.location = t2.location
ORDER BY 1


-- Join table daily total percentageInfected and DeathPercentage with total test and vaccination for every location
WITH t1 AS
(SELECT t.location,
        t.date,
        t.totalPopulation, 
        t.totalCases, 
        (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
        t.totalDeaths, 
        (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
 FROM 
    (SELECT location,
            date,
            MAX(population) AS totalPopulation,
            MAX(total_cases) AS totalCases, 
            MAX(total_deaths) AS totalDeaths
    FROM Portofolio.CovidDeath
    WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
    GROUP BY location, date) AS t
GROUP BY t.location, t.date)

SELECT t1.location,
       t1.date,
       t1.totalPopulation, 
       t2.totalTest, 
       t1.totalCases, 
       t2.totalVac, 
       t1.totalDeaths, 
       (t2.totalTest/t1.totalPopulation)*100 AS PercentageTested, 
       (t1.totalCases/t2.totalTest)*100 AS PositivityRate, 
       t1.totalPercentageInfected, 
       (t2.totalVac/t1.totalPopulation)*100 AS PercentageVaccinated, 
       t1.totalDeathPercentage
FROM t1 
JOIN 
    (SELECT t.location,
            t.date,
            CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
            CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
     FROM
        (SELECT location, 
                date,
                MAX(total_tests) AS m_test, 
                SUM(new_tests) AS sn_test, 
                MAX(total_vaccinations) AS m_vac, 
                SUM(new_vaccinations) AS sn_vac
         FROM Portofolio.CovidVaccination
         WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
         GROUP BY location, date 
         ORDER BY 1) AS t 
    ) AS t2 
ON t1.location = t2.location AND t1.date = t2.date
ORDER BY 1,2


-- Continent section
-- Join table total percentageInfected and DeathPercentage with total test and vaccination for every continent
WITH tab1 AS
            (SELECT t.location, 
                    t.totalPopulation, 
                    t.totalCases, 
                    (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
                    t.totalDeaths, 
                    (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
             FROM 
                (SELECT location,  
                        MAX(population) AS totalPopulation, 
                        MAX(total_cases) AS totalCases, 
                        MAX(total_deaths) AS totalDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY location) AS t
             GROUP BY t.location)

SELECT tab1.location, 
       tab1.totalPopulation, 
       tab2.totalTest, 
       tab1.totalCases, 
       tab2.totalVac, 
       tab1.totalDeaths, 
       (tab2.totalTest/tab1.totalPopulation)*100 AS PercentageTested, 
       (tab1.totalCases/tab2.totalTest)*100 AS PositivityRate, 
       tab1.totalPercentageInfected, 
       (tab2.totalVac/tab1.totalPopulation)*100 AS PercentageVaccinated, 
       tab1.totalDeathPercentage
FROM tab1 
JOIN
    (SELECT t1.continent, 
            SUM(t1.totalTest) AS totalTest, 
            SUM(t1.totalVac) AS totalVac  
    FROM 
        (SELECT t.continent, 
                t.location,
                CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
                CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
         FROM
            (SELECT continent, 
                    location, 
                    MAX(total_tests) AS m_test, 
                    SUM(new_tests) AS sn_test, 
                    MAX(total_vaccinations) AS m_vac, 
                    SUM(new_vaccinations) AS sn_vac
             FROM Portofolio.CovidVaccination
             WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
             GROUP BY continent, location) AS t
         ) AS t1
    GROUP BY t1.continent
    ) AS tab2 
ON tab1.location = tab2.continent
ORDER BY 1


-- Join table daily total percentageInfected and DeathPercentage with total test and vaccination for every continent
WITH tab1 AS
            (SELECT t.location, 
                    t.date,
                    t.totalPopulation, 
                    t.totalCases, 
                    (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
                    t.totalDeaths, 
                    (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
             FROM 
                (SELECT location,
                        date,
                        MAX(population) AS totalPopulation, 
                        MAX(total_cases) AS totalCases, 
                        MAX(total_deaths) AS totalDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY location, date) AS t
             GROUP BY t.location, t.date)

SELECT tab1.location,
       tab1.date,
       tab1.totalPopulation, 
       tab2.totalTest, 
       tab1.totalCases, 
       tab2.totalVac, 
       tab1.totalDeaths, 
       (tab2.totalTest/tab1.totalPopulation)*100 AS PercentageTested, 
       (tab1.totalCases/tab2.totalTest)*100 AS PositivityRate, 
       tab1.totalPercentageInfected, 
       (tab2.totalVac/tab1.totalPopulation)*100 AS PercentageVaccinated, 
       tab1.totalDeathPercentage
FROM tab1 
JOIN
    (SELECT t1.continent,
            t1.date,
            SUM(t1.totalTest) AS totalTest, 
            SUM(t1.totalVac) AS totalVac  
    FROM 
        (SELECT t.continent, 
                t.location,
                t.date,
                CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
                CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
         FROM
            (SELECT continent, 
                    location,
                    date,
                    MAX(total_tests) AS m_test, 
                    SUM(new_tests) AS sn_test, 
                    MAX(total_vaccinations) AS m_vac, 
                    SUM(new_vaccinations) AS sn_vac
             FROM Portofolio.CovidVaccination
             WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
             GROUP BY continent, location, date) AS t
         ) AS t1
    GROUP BY t1.continent, t1.date
    ) AS tab2 
ON tab1.location = tab2.continent AND tab1.date = tab2.date
ORDER BY 1,2

-- World section
-- Join table total percentageInfected and DeathPercentage with total test and vaccination for world
SELECT 'World' AS location,
       SUM(totalPopulation) AS totalPopulation, 
       SUM(totalTest) AS totalTests, 
       SUM(totalCases) AS totalCases, 
       SUM(totalVac) AS totalVac, 
       SUM(totalDeaths) AS totalDeaths, 
       (SUM(totalTest)/SUM(totalPopulation))*100 AS PercentageTested, 
       (SUM(totalCases)/SUM(totalTest))*100 AS PositivityRate, 
       (SUM(totalCases)/SUM(totalPopulation))*100 AS totalPercentageInfected, 
       (SUM(totalVac)/SUM(totalPopulation))*100 AS PercentageVaccinated, 
       (SUM(totalDeaths)/SUM(totalCases))*100 AS totalDeathPercentage
FROM
    (WITH tab1 AS
            (SELECT t.location, 
                    t.totalPopulation, 
                    t.totalCases, 
                    (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
                    t.totalDeaths, 
                    (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
             FROM 
                (SELECT location,  
                        MAX(population) AS totalPopulation, 
                        MAX(total_cases) AS totalCases, 
                        MAX(total_deaths) AS totalDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY location) AS t
             GROUP BY t.location)
             
     SELECT tab1.location, 
            tab1.totalPopulation, 
            tab2.totalTest, 
            tab1.totalCases, 
            tab2.totalVac, 
            tab1.totalDeaths, 
            (tab2.totalTest/tab1.totalPopulation)*100 AS PercentageTested, 
            (tab1.totalCases/tab2.totalTest)*100 AS PositivityRate, 
            tab1.totalPercentageInfected, 
            (tab2.totalVac/tab1.totalPopulation)*100 AS totalVaccinated, 
            tab1.totalDeathPercentage
     FROM tab1 
     JOIN
         (SELECT t1.continent, 
                 SUM(t1.totalTest) AS totalTest, 
                 SUM(t1.totalVac) AS totalVac  
          FROM 
             (SELECT t.continent, 
                     t.location,
                     CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
                     CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
              FROM
                (SELECT continent, 
                        location, 
                        MAX(total_tests) AS m_test, 
                        SUM(new_tests) AS sn_test, 
                        MAX(total_vaccinations) AS m_vac, 
                        SUM(new_vaccinations) AS sn_vac
                 FROM Portofolio.CovidVaccination
                 WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY continent, location) AS t
             ) AS t1
          GROUP BY t1.continent
         ) AS tab2 
     ON tab1.location = tab2.continent
    ) AS tab
    
    
-- Join table daily total percentageInfected and DeathPercentage with total test and vaccination for world
SELECT 'World' AS location,
       date,
       SUM(totalPopulation) AS totalPopulation, 
       SUM(totalTest) AS totalTests, 
       SUM(totalCases) AS totalCases, 
       SUM(totalVac) AS totalVac, 
       SUM(totalDeaths) AS totalDeaths, 
       (SUM(totalTest)/SUM(totalPopulation))*100 AS PercentageTested, 
       (SUM(totalCases)/SUM(totalTest))*100 AS PositivityRate, 
       (SUM(totalCases)/SUM(totalPopulation))*100 AS totalPercentageInfected, 
       (SUM(totalVac)/SUM(totalPopulation))*100 AS PercentageVaccinated, 
       (SUM(totalDeaths)/SUM(totalCases))*100 AS totalDeathPercentage
FROM
    (WITH tab1 AS
            (SELECT t.location,
                    t.date,
                    t.totalPopulation, 
                    t.totalCases, 
                    (t.totalCases/t.totalPopulation)*100 AS totalPercentageInfected, 
                    t.totalDeaths, 
                    (t.totalDeaths/t.totalCases)*100 AS totalDeathPercentage
             FROM 
                (SELECT location,
                        date,
                        MAX(population) AS totalPopulation, 
                        MAX(total_cases) AS totalCases, 
                        MAX(total_deaths) AS totalDeaths
                 FROM Portofolio.CovidDeath
                 WHERE continent IS NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY location, date) AS t
             GROUP BY t.location, t.date)
             
     SELECT tab1.location,
            tab1.date,
            tab1.totalPopulation, 
            tab2.totalTest, 
            tab1.totalCases, 
            tab2.totalVac, 
            tab1.totalDeaths, 
            (tab2.totalTest/tab1.totalPopulation)*100 AS PercentageTested, 
            (tab1.totalCases/tab2.totalTest)*100 AS PositivityRate, 
            tab1.totalPercentageInfected, 
            (tab2.totalVac/tab1.totalPopulation)*100 AS PercentageVaccinated, 
            tab1.totalDeathPercentage
     FROM tab1 
     JOIN
         (SELECT t1.continent,
                 t1.date,
                 SUM(t1.totalTest) AS totalTest, 
                 SUM(t1.totalVac) AS totalVac  
          FROM 
             (SELECT t.continent, 
                     t.location,
                     t.date,
                     CASE WHEN IFNULL(t.m_test,0) > IFNULL(t.sn_test,0) THEN IFNULL(t.m_test,0) ELSE IFNULL(t.sn_test,0) END AS totalTest,
                     CASE WHEN IFNULL(t.m_vac,0) > IFNULL(t.sn_vac,0) THEN IFNULL(t.m_vac,0) ELSE IFNULL(t.sn_vac,0) END AS totalVac
              FROM
                (SELECT continent, 
                        location,
                        date,
                        MAX(total_tests) AS m_test, 
                        SUM(new_tests) AS sn_test, 
                        MAX(total_vaccinations) AS m_vac, 
                        SUM(new_vaccinations) AS sn_vac
                 FROM Portofolio.CovidVaccination
                 WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
                 GROUP BY continent, location, date) AS t
             ) AS t1
          GROUP BY t1.continent, t1.date
         ) AS tab2 
     ON tab1.location = tab2.continent AND tab1.date = tab2.date
    ) AS tab
GROUP BY date
ORDER BY 1,2

-- Data extraction to obtain data for visualization
-- Create virtual table that contain joined table with specific columns
CREATE VIEW join_table AS
(SELECT cd.continent, 
        cd.location,
        cd.date,
        cd.population,
        cd.new_cases,
        cd.new_deaths,
        cv.new_tests,
        cv.new_vaccinations 
FROM Portofolio.CovidDeath cd 
JOIN Portofolio.CovidVaccination cv 
ON cd.location = cv.location  AND cd.date = cv.date
ORDER BY cd.location, cd.date)

-- Daily number
-- Create view for daily cases in every location
CREATE VIEW loc_daily AS 
    (SELECT continent,
            location,
            date,
            MAX(population) OVER (PARTITION BY location) AS population,
            SUM(IFNULL(new_cases,0)) OVER (PARTITION BY location ORDER BY location, date) AS total_cases,
            SUM(IFNULL(new_deaths,0)) OVER (PARTITION BY location ORDER BY location, date) AS total_deaths,
            SUM(IFNULL(new_tests,0)) OVER (PARTITION BY location ORDER BY location, date) AS total_tests,
            SUM(IFNULL(new_vaccinations,0)) OVER (PARTITION BY location ORDER BY location, date) AS total_vaccinations
     FROM join_table
     WHERE continent IS NOT NULL AND location NOT IN ('European Union','High income', 'International','Low income','Lower middle income','Upper middle income','World')
     ORDER BY 2,3)
    
-- Create view for daily cases in every continent
-- Created by calculating the sum for each continent from loc_daily view
CREATE VIEW cont_daily AS
    (WITH t1 AS
     (SELECT continent,
            date,
            SUM(new_cases) OVER (PARTITION BY continent ORDER BY continent, date) AS total_cases,
            SUM(new_deaths) OVER (PARTITION BY continent ORDER BY continent, date) AS total_deaths,
            SUM(new_tests) OVER (PARTITION BY continent ORDER BY continent, date) AS total_tests,
            SUM(new_vaccinations) OVER (PARTITION BY continent ORDER BY continent, date) AS total_vaccinations
     FROM
        (SELECT continent,
                date,
                SUM(total_cases) AS new_cases,
                SUM(total_deaths) AS new_deaths,
                SUM(total_tests) AS new_tests,
                SUM(total_vaccinations) AS new_vaccinations
         FROM loc_daily
         GROUP BY continent,`date` 
         ORDER BY 1,2) AS t
     ORDER BY 1,2)
    
    SELECT t1.continent AS location,
           t1.date,
           t2.population,
           t1.total_cases,
           t1.total_deaths,
           t1.total_tests,
           t1.total_vaccinations
    FROM t1
    LEFT JOIN
        (SELECT continent, 
                SUM(population) AS population
         FROM 
            (SELECT continent, 
                    location, 
                    MAX(population) AS population 
             FROM loc_daily
             GROUP BY continent, location
             ORDER BY 1, 2) AS t
             GROUP BY continent 
             ORDER BY 1) AS t2
    ON t1.continent = t2.continent
    ORDER BY 1,2)
    
    SELECT * FROM cont_daily

-- Create view for global cases by using view cont_daily
CREATE VIEW world_daily AS
(WITH t1 AS
    (SELECT 'World' AS location,
            date,
            SUM(total_cases) OVER (PARTITION BY date) AS total_cases,
            SUM(total_deaths) OVER (PARTITION BY date) AS total_deaths,
            SUM(total_tests) OVER (PARTITION BY date) AS total_tests,
            SUM(total_vaccinations) OVER (PARTITION BY date) AS total_vaccinations
     FROM
        (SELECT date, 
                SUM(total_cases) AS total_cases, 
                SUM(total_deaths) AS total_deaths, 
                SUM(total_tests) AS total_tests, 
                SUM(total_vaccinations) AS total_vaccinations
         FROM cont_daily
         GROUP BY `date` 
         ORDER BY 1) AS t
    ORDER BY 1,2)

SELECT t1.location,
       t1.date,
       t2.population,
       t1.total_cases,
       t1.total_deaths,
       t1.total_tests,
       t1.total_vaccinations
FROM t1
LEFT JOIN
    (SELECT 'World' AS location, 
            SUM(population) AS population
     FROM 
        (SELECT continent, 
                location, 
                MAX(population) AS population 
         FROM loc_daily
         GROUP BY continent, location
         ORDER BY 1, 2) AS t
     ORDER BY 1) AS t2
ON t1.location = t2.location
ORDER BY 1,2)

-- Merge the three view by using UNION and calculate the percentage of infected, deaths, test, positivity rate, and vaccination
SELECT location,
       date,
       population,
       total_cases,
       total_deaths,
       total_tests,
       total_vaccinations,
       (total_tests/population)*100 AS PercentageTested,
       (total_cases/population)*100 AS PercentageInfected,
       (total_cases/total_tests)*100 AS PositivityRate,
       (total_deaths/total_cases)*100 AS DeathPercentage,
       (total_vaccinations/population) AS PercentageVaccinated 
FROM       
    (SELECT location,
            date,
            population,
            total_cases,
            total_deaths,
            total_tests,
            total_vaccinations
     FROM loc_daily ld
     UNION
        (SELECT * FROM cont_daily)
     UNION
        (SELECT * FROM world_daily)) AS t
ORDER BY 1,2