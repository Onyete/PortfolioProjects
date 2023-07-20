Select * 
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4

--select Data that we are going to be using

Select location, date, total_cases,new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


-- Looking at the Total Cases vs Total Deaths
-- Shows the likelihood of dieing if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

-- The Total Cases vs Population
-- Show what percentage of population got Covid

Select location, date, population, total_cases, (total_deaths/population)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
Order by 1,2


-- Looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
Group by location, population
Order by PercentPopulationInfected desc 

-- Showing the countries with the highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
Group by location
Order by TotalDeathCount desc 

--LETS BREAK THINGS DOWN BY CONTINENT
--Use 'Group by' for Aggregate functions

--Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
--where continent is null
--Group by location
--Order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
Group by continent
Order by TotalDeathCount desc



-- Global Numbers

Select date, SUM(new_cases)--, SUM(new_deaths)--, (total_deaths/total_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Where Continent is not null
Group by date
Order by 1,2

Select Date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, 
SUM(cast(new_deaths as int))/SUM(New_cases)* 100 as PercentNewDeaths 
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Where Continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, 
SUM(cast(new_deaths as int))/SUM(New_cases)* 100 as PercentNewDeaths 
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Where Continent is not null
--Group by date
Order by 1,2

Select * from PortfolioProject.dbo.CovidVaccinations

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


--Using CTEs to get the total number of people vaccinated

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


Select *
From PercentagePopulationVaccinated



