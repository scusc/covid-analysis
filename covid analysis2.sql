select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from covid_project..coviddeaths
where continent is not null
order by 1,2;

select location, sum(cast(new_deaths as int)) as totaldeathcount
from covid_project..coviddeaths
where continent is null
and location not in ('World','European Union','International')
group by location
order by totaldeathcount desc;

select location, population, max(total_cases) as hihginfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from covid_project..coviddeaths
group by location, population
order by percentpopulationinfected desc;

select location, population, date, max(total_cases) as hihginfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from covid_project..coviddeaths
group by location, population, date
order by percentpopulationinfected desc;