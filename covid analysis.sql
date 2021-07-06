select * from covid_project..coviddeaths where continent is not null;

select * from covid_project..covidvaccinations where continent is not null;

select location, date, total_cases, new_cases, total_deaths, population 
from covid_project..coviddeaths where continent is not null order by 1,2;

select location, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage from covid_project..coviddeaths where location like '%states%' and continent is not null order by 1,2;

select location, total_cases, population, (total_cases/population)*100 as percentage_effected from covid_project..coviddeaths where location like '%states%' and continent is not null order by 1,2;

select location, population, max(total_cases) as highest_cases, max((total_cases/population)*100) as percentage_effected from covid_project..coviddeaths where continent is not null group by location, population order by percentage_effected desc;

select continent, max(cast(total_deaths as int)) as highest_death from covid_project..coviddeaths where continent is not null group by continent order by highest_death desc;


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as deathpercentage from covid_project..coviddeaths where continent is not null  order by 1,2;


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..coviddeaths dea
Join covid_project..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..coviddeaths dea
Join covid_project..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated



Create View pervac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..coviddeaths dea
Join covid_project..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
 

 select * from pervac








