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