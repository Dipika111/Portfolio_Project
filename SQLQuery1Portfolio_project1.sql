Select *
From portfolio_project1..CovidDeaths
Where continent is not null
Order by 1,2

--Select *
--From portfolio_project1..CovidVaccinations
--Where continent is not null
--Order by 3,4

--Data that we are going to use

Select Location, date, total_cases, 
new_cases, total_deaths, population
From portfolio_project1..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at total cases vs total cases

Select Location, date, total_cases, total_deaths, 
(total_cases/total_deaths)*100 as DeathPercentage
From portfolio_project1..CovidDeaths
Where location like '%india%'
and continent is not null
Order by 1,2

--Looking at total cases vs population

Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From portfolio_project1..CovidDeaths
Where location like '%india%'
and continent is not null
Order by 1,2

--Looking at contries with highest infection rate compaqred to population

Select Location, population, Max(total_cases/population) as HighInfectionCount, 
Max(total_cases/population)*100 as PercentagePopolutionInfected
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by location, population
Order by PercentagePopolutionInfected desc

--Showing continents with the highest death count per polulation

Select continent, Max(cast (total_deaths as int)) as TotalDeathCount 
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--Showing countries with highest deaths count per population

Select location, Max(cast (total_deaths as int)) as TotalDeathCount 
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Showing continents with the highest death count per polulation

Select Location, population, Max(total_cases/population) as HighInfectionCount, 
Max(total_cases/population)*100 as PercentagePopolutionInfected
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by location, population
Order by PercentagePopolutionInfected desc


Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Group by location
Order by TotalDeathCount desc


--Global Numbers


Select SUM(new_cases) as total_cases, SUM(CONVERT(int, new_deaths)) 
as total_deaths, SUM(CONVERT(int, new_deaths)) / SUM(new_cases)*100 as DeathPercentage 
From portfolio_project1..CovidDeaths
--Where location like '%india%'
Where continent is not null
--group by date
Order by 1,2


--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, 
dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From portfolio_project1..CovidDeaths dea
join portfolio_project1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE 

With PopvsVac (continent, location, date , population, New_vaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, 
dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From portfolio_project1..CovidDeaths dea
join portfolio_project1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--TEMP Table

DROP Table if exists #
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, 
dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From portfolio_project1..CovidDeaths dea
join portfolio_project1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from  #PercentPopulationVaccinated



---Creating view to store data for lator visualizations

CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, 
dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
From portfolio_project1..CovidDeaths dea
join portfolio_project1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated