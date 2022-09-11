create database portfolio;
use portfolio;

select * from coviddeaths
order by 3, 4;

select location, date, population, total_cases, new_cases, total_deaths
from coviddeaths
order by 1, 2;

-- Looking  at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from coviddeaths
where location like '%States%'
order by 1,2;

-- Looking at total cases vs population

select location, date, population, total_cases, (total_cases/population)*100 as Death_p
from coviddeaths
-- where location like '%Korea%'
order by 1, 2;

-- Looking at total location
 
select location, count(location) 
from coviddeaths
group by location;

-- Looking at Countries with Highest Infection Rate Compare to Population

select location, population, max(total_cases) as HighestInfection_count, max(total_cases/population)*100 as percent_population_infected
from coviddeaths
group by location, population
order by percent_population_infected desc;

-- Showing the countries with Highest Death count

select location, population, count(total_deaths) as Total_Death_Count
from coviddeaths
where continent is not null
group by location, population
order by Total_Death_Count desc;

-- Showing continents with the highest death count 

select location, continent, count(total_deaths ) as Total_Deaths_count
from coviddeaths
where continent is not null
group by location, continent
order by Total_Deaths_count desc;

-- Global Numbers

select date, sum(new_cases) as New_cases, sum(new_deaths) as new_deaths
from coviddeaths
where continent is not null
group by date
order by 1, 2;


select  sum(new_cases) as total_New_cases, sum(new_deaths) as new_deaths,
sum(new_deaths)/sum(new_cases)*100 as Death_Percentage
from coviddeaths
where continent is not null
-- group by date
order by 1, 2;

-- Join two tables

select *
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date; 


-- Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3; 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinated
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3; 

-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccination, RollingPeopleVacinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinated
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select * , (RollingPeopleVacinated/population)*100 as Rolling_Data
from PopvsVac; 







