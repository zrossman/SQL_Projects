select *
from Project.`Covid_Deaths`;


#Total Cases Vs Total Deaths, Death Rate
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Rate
from Project.`Covid_Deaths`
where location like '%states%'
order by location, total_cases;


#Total Cases Vs Population
select location, date, total_cases, population, (total_cases/population)*100 as Infected_percentage
from Project.`Covid_Deaths`
where location like '%states%'
order by location, total_cases;


#Countries with Highest Infection Rate
select location, max(total_cases), population, max((total_cases/population))*100 as Max_Infected_Percentage
from Project.`Covid_Deaths`
group by location, population
order by Max_Infected_Percentage desc;

#Countries With Highest Death Count per Population
select location, max(cast(total_deaths as unsigned)) as Total_Death_Count
from Project.`Covid_Deaths`
where continent != ''
group by location
order by Total_Death_Count desc;

#Now lets take a look at the continents
select continent, sum(new_deaths) as Total_Death_Count
from Project.`Covid_Deaths`
where continent != ''
group by continent
order by Total_Death_Count desc;

#Taking a look globally by day
select date, sum(new_cases) as New_Cases, sum(new_deaths) as New_Deaths
from Project.`Covid_Deaths`
group by date;

#Total Global Numbers
select sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, (sum(new_deaths) / sum(new_cases)) * 100 as Death_Percentage
from Project.`Covid_Deaths`;


select *
from Project.`Covid_Vaccinations`;

#Looking at total vaccinations vs population for each country
select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations, sum(cast(vacs.new_vaccinations as unsigned)) over (partition by deaths.location order by deaths.location, deaths.date) as Rolling_Vac_Total
from Project.`Covid_Vaccinations` vacs
join Project.`Covid_Deaths` deaths
on deaths.location = vacs.location
and deaths.date = vacs.date
order by location, date