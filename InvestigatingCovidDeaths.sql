Select *
From PortfolioProject1_Covid..CovidDeaths
Where continent IS NOT NULL
Order by 3,4

-- Select *
-- From CovidVaccinations
-- Order by 3,4

-- Select the data that we are going to be using

Select location, date, total_cases,new_cases, total_deaths, population
From PortfolioProject1_Covid..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As PercentageDeathRate
From PortfolioProject1_Covid..CovidDeaths
Where location like '%india%'
Order by 1,2

-- Looking at Total cases vs Population
-- Shows the infection rate of the population in your country

Select location, date, population, total_cases, (total_cases/population)*100 As PercentageInfectionRate
From PortfolioProject1_Covid..CovidDeaths
-- Where location like '%india%'
Order by 1,2


-- Looking at countries with highest infection rate compared to population

Select location, population, max(total_cases) As HighestInfectionCount, (max(total_cases/population))*100 As PercentHighestInfectionRate
From PortfolioProject1_Covid..CovidDeaths
-- Where location like '%india%'
Group by population,location
Order by PercentHighestInfectionRate Desc


-- Showing countries with Highest Death count per population

Select location, population, MAX(cast(total_deaths As int)) As HighestDeathCount
From PortfolioProject1_Covid..CovidDeaths
Where continent Is Not NULL
-- Where location like '%india%'
Group by population,location
Order by HighestDeathCount Desc


-- LETS START LOOKING AT CONTINENT NUMBERS
-- Showing the continents with Highest Death count per population

Select continent, MAX(cast(total_deaths As int)) As HighestDeathCount
From PortfolioProject1_Covid..CovidDeaths
Where continent Is Not NULL
-- Where continent Like '%America%'
Group by continent
Order by HighestDeathCount Desc


-- Shows death numbers every day in all continents

Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM (cast(new_deaths as int))/SUM(new_cases)*100 As PercentageDeathRate
From PortfolioProject1_Covid..CovidDeaths
Where continent is not Null
Group by date
Order by 1,2


-- Shows total deaths in the world as a whole

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM (cast(new_deaths as int))/SUM(new_cases)*100 As PercentageDeathRate
From PortfolioProject1_Covid..CovidDeaths
Where continent is not Null
-- Group by date
Order by 1,2


-- Looking at Daily New vaccinations in the world population with a rolling count
-- Error 'Arithmetic overflow error converting expression to data type int. Warning: Null value is eliminated by an aggregate or other SET operation'  was corrected by using BIGINT instead of int.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--  , (RollingPeopleVccinated/Population)*100
From PortfolioProject1_Covid..CovidDeaths dea
Join PortfolioProject1_Covid..CovidVaccinations vac
	On dea.location = vac.location  
	and dea.date = vac.date
Where dea.continent is NOT NULL
Order by 2,3


-- Use CTE

	With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	--  , (RollingPeopleVaccinated/Population)*100
	From PortfolioProject1_Covid..CovidDeaths dea
	Join PortfolioProject1_Covid..CovidVaccinations vac
		On dea.location = vac.location  
		and dea.date = vac.date
	Where dea.continent is NOT NULL
	-- Order by 2,3
	)

	Select *, (RollingPeopleVaccinated/Population)*100
	From PopvsVac


	--TEMP TABLE

	Drop Table if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	--  , (RollingPeopleVaccinated/Population)*100
	From PortfolioProject1_Covid..CovidDeaths dea
	Join PortfolioProject1_Covid..CovidVaccinations vac
		On dea.location = vac.location  
		and dea.date = vac.date
	-- Where dea.continent is NOT NULL
	-- Order by 2,3

		Select *, (RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated



-- Creating View to store data for later visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--  , (RollingPeopleVaccinated/Population)*100
From PortfolioProject1_Covid..CovidDeaths dea
Join PortfolioProject1_Covid..CovidVaccinations vac
	On dea.location = vac.location  
	and dea.date = vac.date
Where dea.continent is NOT NULL
--Order by 2,3

Select *
From PercentPopulationVaccinated


Create view HighestDeathCount as
Select continent, MAX(cast(total_deaths As int)) As HighestDeathCount
From PortfolioProject1_Covid..CovidDeaths
Where continent Is Not NULL
-- Where continent Like '%America%'
Group by continent
--Order by HighestDeathCount Desc


Select *
From HighestDeathCount
