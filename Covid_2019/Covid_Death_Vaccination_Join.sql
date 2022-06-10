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
       (t2.totalVac/t1.totalPopulation)*100 AS totalVaccinated, 
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
       (t2.totalVac/t1.totalPopulation)*100 AS totalVaccinated, 
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
ORDER BY 1


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
       (tab2.totalVac/tab1.totalPopulation)*100 AS totalVaccinated, 
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


-- Join table total percentageInfected and DeathPercentage with total test and vaccination for world
SELECT 'World' AS continent,
       SUM(totalPopulation) AS totalPopulation, 
       SUM(totalTest) AS totalTests, 
       SUM(totalCases) AS totalCases, 
       SUM(totalVac) AS totalVac, 
       SUM(totalDeaths) AS totalDeaths, 
       (SUM(totalTest)/SUM(totalPopulation))*100 AS PercentageTested, 
       (SUM(totalCases)/SUM(totalTest))*100 AS PositivityRate, 
       (SUM(totalCases)/SUM(totalPopulation))*100 AS totalPercentageInfected, 
       (SUM(totalVac)/SUM(totalPopulation))*100 AS totalVaccinated, 
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
    
    
-- Join table total percentageInfected and DeathPercentage with total test and vaccination for world
SELECT 'World' AS continent,
       date,
       SUM(totalPopulation) AS totalPopulation, 
       SUM(totalTest) AS totalTests, 
       SUM(totalCases) AS totalCases, 
       SUM(totalVac) AS totalVac, 
       SUM(totalDeaths) AS totalDeaths, 
       (SUM(totalTest)/SUM(totalPopulation))*100 AS PercentageTested, 
       (SUM(totalCases)/SUM(totalTest))*100 AS PositivityRate, 
       (SUM(totalCases)/SUM(totalPopulation))*100 AS totalPercentageInfected, 
       (SUM(totalVac)/SUM(totalPopulation))*100 AS totalVaccinated, 
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
            (tab2.totalVac/tab1.totalPopulation)*100 AS totalVaccinated, 
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
ORDER BY 1