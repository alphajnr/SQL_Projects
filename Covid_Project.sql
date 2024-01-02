Select * 
FROM SQL_Project_1.dbo.Covid_Deaths$
--Display records for the undermentioned fields

Select location,date,total_cases,new_cases,total_deaths,population
From SQL_Project_1.dbo.Covid_Deaths$
Where continent is Not Null
Order By 1,2

-- Calculate Total Deaths by Percentage in your country

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 As Death_Percentage
From SQL_Project_1.dbo.Covid_Deaths$
where location like '%Sierra Leone%' And continent is Not Null
Order By 1,2

--  Total Population Cases got by Percentage in your country

Select location,date,population, total_cases, (total_deaths/Population)*100 As Population_Percentage
From SQL_Project_1.dbo.Covid_Deaths$
where location like '%Sierra Leone%'
Order By 1,2


--  Total Population Cases got by Percentage in your country

Select location,population, MAX(total_cases) as HightestInfectionCoutn, MAX(total_deaths/Population)*100 As Infected_Percentage_Population
From SQL_Project_1.dbo.Covid_Deaths$
Where continent is Not Null
Group By location, population
Order By Infected_Percentage_Population DESC

--   Countries with the Highest Death Cases 

Select location, MAX(cast(total_deaths as int)) As TotalDeath
From SQL_Project_1.dbo.Covid_Deaths$
Where continent is Not Null 
Group By location 
Order By TotalDeath DESC

--   Continent with the Highest Death Cases 

Select continent, MAX(cast(total_deaths as int)) As TotalDeath
From SQL_Project_1.dbo.Covid_Deaths$
Where continent is Not  Null 
Group By continent 
Order By TotalDeath DESC

-- Global Numbers

Select date, Sum(new_cases) As Total_Cases, Sum(Cast(new_deaths as int)) As TotalDeaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 As DeathPercentage
From SQL_Project_1.dbo.Covid_Deaths$
Where continent is not null
Group By date
Order by 1,2

-- Total Vaccination Population

Select dea.continent, dea.location, vacc.date, dea.population, dea.new_vaccinations,
	Sum(Convert(int,vacc.new_vaccinations)) Over (Partition By dea.Location Order By dea.location, dea.Date) RollingPeopleVaccinated
From SQL_Project_1.dbo.Covid_Deaths$ dea 
Join SQL_Project_1.dbo.CovidVaccinations$ vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
Where  dea.continent is not null 
Order By 2,3

-- Population and Vaccinated
With PopVSVac (Continent, Location, Population, New_vaccinations, RollingPeopleVaccinated)
as ( 
Select dea.continent, dea.location, dea.population, dea.new_vaccinations,
	Sum(Convert(int,vacc.new_vaccinations)) Over (Partition By dea.Location Order By dea.location, dea.Date) RollingPeopleVaccinated
From SQL_Project_1.dbo.Covid_Deaths$ dea 
Join SQL_Project_1.dbo.CovidVaccinations$ vacc
	On dea.location = vacc.location
Where  dea.continent is not null 
--Order By 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVSVac

--Monthly Trends
SELECT 
    Month(date) AS month,
    SUM(Convert(float,new_cases)) AS monthly_new_cases,
    SUM(Convert(float,new_deaths)) AS monthly_deaths
FROM SQL_Project_1.dbo.Covid_Deaths$
GROUP BY date
ORDER BY date;

-- HIGHEST AND LOWEST DAILY CASES
SELECT 
	date, new_cases
FROM SQL_Project_1.dbo.Covid_Deaths$
ORDER BY new_cases DESC;


SELECT 
	 date, new_cases
FROM SQL_Project_1.dbo.Covid_Deaths$
ORDER BY new_cases

-- DAILY AVERAGE NEW CASES
SELECT
	AVG(CAST(new_cases AS float)) as DailyAverages
FROM SQL_Project_1.dbo.Covid_Deaths$