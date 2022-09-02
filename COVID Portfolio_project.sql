/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


select * from project_portfolio..CovidDeaths where continent is not null order by 3,4

select * from project_portfolio..CovidVaccinations

-- Select Data that we are going to be starting with

select Location, date, total_cases,new_cases, total_deaths, population from project_portfolio..CovidDeaths order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Percentage 
from project_portfolio..CovidDeaths
where location = 'India'  order by 1,2

select Location, date, total_cases,population, (total_cases/population)*100 as perc_infected 
from project_portfolio..CovidDeaths 
where location = 'India' order by 1,2

-- Continent wise Break up
-- Countries with Highest Infection Rate compared to Population

select Location, Max(total_cases) as Infection_count,population, 
Max((total_cases/population))*100 as perc_infected from project_portfolio..CovidDeaths 
 Group by Location, population order by perc_infected desc

 select location, Max(cast(total_deaths as int)) as death_count from project_portfolio..CovidDeaths 
 where continent is not null group by location order by death_count desc
 
 select continent, Max(cast(total_deaths as int)) as death_count from project_portfolio..CovidDeaths 
 where continent is not null group by continent order by death_count desc

 -- Global Numbers

 select date, sum(new_cases) as summed_cases from project_portfolio..CovidDeaths 
 where continent is not null group by date order by summed_cases desc
 
 select date, sum(cast(new_deaths as int)) as summed_deaths from project_portfolio..CovidDeaths 
 where continent is not null group by date order by summed_deaths desc

 select date, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_perc 
 from project_portfolio..CovidDeaths 
 where continent is not null group by date order by Death_perc desc

 select sum(new_cases) as summed_cases, sum(cast(new_deaths as int)) as summed_deaths,
 sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_perc 
 from project_portfolio..CovidDeaths 
 where continent is not null order by Death_perc desc

select a.continent,a.location, a.date, a.population, b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over(Partition by a.location order by a.location,a.date) as rolling_vacc 
from project_portfolio..CovidDeaths a join project_portfolio..CovidVaccinations b on a.date = b.date and a.location=b.location
where a.continent is not null order by 2,3

-- using CTE
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_vacc) as
(select a.continent,a.location, a.date, a.population, b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over(Partition by a.location order by a.location,a.date) as rolling_vacc 
from project_portfolio..CovidDeaths a join project_portfolio..CovidVaccinations b on a.date = b.date and a.location=b.location
where a.continent is not null )

select *,(rolling_vacc/population)*100 as roll_perc from PopvsVac

--Temp Table
-- Using Temp Table to perform Calculation on Partition By in previous query

Drop Table if exists #PercentpopulationVaccinated
Create Table #PercentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_vacc numeric
)
Insert into #PercentpopulationVaccinated
select a.continent,a.location, a.date, a.population, b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over(Partition by a.location order by a.location,a.date) as rolling_vacc 
from project_portfolio..CovidDeaths a join project_portfolio..CovidVaccinations b on a.date = b.date and a.location=b.location

select *,(rolling_vacc/population)*100 as roll_perc from #PercentpopulationVaccinated



--Creating View to save Data for later visualizations

Create View PercentagepopulationVaccinated as 
select a.continent,a.location, a.date, a.population, b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over(Partition by a.location order by a.location,a.date) as rolling_vacc 
from project_portfolio..CovidDeaths a join project_portfolio..CovidVaccinations b on a.date = b.date and a.location=b.location
where a.continent is not null

select * from PercentagepopulationVaccinated










