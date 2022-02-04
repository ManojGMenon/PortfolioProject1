Select *
From PortfolioProject1..CovidDeaths
Where continent IS NOT NULL
Order by 3,4

-- Select *
-- From CovidVaccinations
-- Order by 3,4

-- Select the data that we are going to be using

Select location, date, total_cases,new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihooe of dying if you contract Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As PercentageDeathRate
From PortfolioProject1..CovidDeaths
Where location like '%india%'
Order by 1,2

-- Looking at Total cases vs Population
-- Shows the infection rate of the population in your country

Select location, date, population, total_cases, (total_cases/population)*100 As PercentageInfectionRate
From PortfolioProject1..CovidDeaths
-- Where location like '%india%'
Order by 1,2


-- Looking at countries with highest infection rate compared to population

Select location, population, max(total_cases) As HighestInfectionCount, (max(total_cases/population))*100 As PercentHighestInfectionRate
From PortfolioProject1..CovidDeaths
-- Where location like '%india%'
Group by population,location
Order by PercentHighestInfectionRate Desc


-- Showing countries with Highest Death count per population

Select location, population, MAX(cast(total_deaths As int)) As HighestDeathCount
From PortfolioProject1..CovidDeaths
Where continent Is Not NULL
-- Where location like '%india%'
Group by population,location
Order by HighestDeathCount Desc

