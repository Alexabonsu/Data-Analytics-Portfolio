SELECT * 
FROM CovidDeaths

SELECT *
FROM CovidVacinations

How many total cases and total deaths were recorded.

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death_covid
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

CREATE VIEW TOTALDEATHS_TOTALCASES AS
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death_covid
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL

SELECT *
FROM TOTALDEATHS_TOTALCASES

how many total cases by population were recorded

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS Cases_By_Population
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
--ORDER BY 1,2

CREATE VIEW Totalcases_population AS
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS Cases_By_Population
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null

SELECT *
FROM Totalcases_population


Countrys with the highest infections rate.

SELECT Location, population, Max(total_cases) AS HighestInfections, Max(total_cases/population)*100 AS Infestion_by_Poulation
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Infestion_by_Poulation DESC

CREATE VIEW  Highest_infections_rate AS
SELECT Location, population, Max(total_cases) AS HighestInfections, Max(total_cases/population)*100 AS Infestion_by_Poulation
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population

SELECT *
FROM Highest_infections_rate


Countrys with the highest death recorded.

SELECT location,  MAX(Cast (total_Deaths AS INT)) AS totaldeathsrecorded
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totaldeathsrecorded DESC

Continent with highest death.

SELECT Continent, Max(cast (total_deaths As INT)) As Continent_with_highdeath
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Continent_with_highdeath DESC

Global Numbers of death percentage

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths As INT)) AS total_deaths
, SUM(Cast(new_deaths AS INT))/SUM(new_cases)*100 AS Globaldeaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

PEOPLE VACCINATED 

SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (Partition BY Dea.location) AS Vaccinations
, (SUM(CAST(VAC.new_vaccinations AS INT)) OVER (Partition BY Dea.location)/population)*100 AS 
Percentage_people_vaccinated
FROM [Portfolio Project].dbo.CovidDeaths AS DEA
INNER JOIN [Portfolio Project].dbo.CovidVacinations AS VAC
   ON DEA.location=VAC.location
      and DEA.date=VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

TEMP TABLE


DROP Table If exists #People_vaccinated
CREATE table #People_vaccinated
(
Continent nvarchar(300),
location nvarchar(300),
Date datetime,
Population numeric,
new_vaccinations numeric,
vaccinated numeric
)

SELECT * FROM #People_vaccinated

INSERT INTO #People_vaccinated
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (Partition BY Dea.location ORDER BY Dea.location, Dea.date) AS vaccinated
, (SUM(CAST(VAC.new_vaccinations AS INT)) OVER (Partition BY Dea.location)/population)*100 AS 
Percentage_people_vaccinated
FROM [Portfolio Project].dbo.CovidDeaths AS DEA
INNER JOIN [Portfolio Project].dbo.CovidVacinations AS VAC
     ON DEA.location=VAC.location
     and DEA.date=VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3
SELECT *, (vaccinated/Population)*100 AS percentage_vaccinated
FROM #People_vaccinated


CREATING VIEWS

CREATE VIEW Global_number_of_Deaths_percentage AS
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths As INT)) AS total_deaths
, SUM(Cast(new_deaths AS INT))/SUM(new_cases)*100 AS Globaldeaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
--ORDER BY 1,2

SELECT * 
FROM Global_number_of_Deaths_percentage

