-- ============================================
-- Table: world
-- Columns: name, continent, area, population, gdp
-- ============================================
-- Sample data (for reference while practicing):
--
-- name          | continent | area      | population  | gdp
-- --------------|-----------|-----------|-------------|---------------
-- Afghanistan   | Asia      | 652230    | 25500100    | 20364000000
-- Albania       | Europe    | 28748     | 2831741     | 12960000000
-- Algeria       | Africa    | 2381741   | 37100000    | 188681000000
-- Russia        | Europe    | 17125242  | 144096812   | 2057000000000
-- Germany       | Europe    | 357114    | 80716000    | 3874437000000
-- France        | Europe    | 547030    | 66999000    | 2807306000000
-- India         | Asia      | 3287263   | 1380004385  | 2875142000000
-- China         | Asia      | 9596961   | 1411778724  | 14342900000000
-- USA           | N.America | 9833517   | 331002651   | 21427700000000
-- Brazil        | S.America | 8515767   | 212559417   | 1839758000000


-- Q1: List all countries with a population larger than that of Russia.

Select name From world where population > (Select population from world where name ="Russia");

-- Q2: List countries in Europe with a GDP greater than France's GDP.

select name from world  where continent = "Europe" and  gdp > (select gdp from world where name= "France" );

-- Q3: Find the name and population of the country with the largest population.
Select name, population FROM world where population = (Select max(population) from world);

-- Q4: List all countries with a GDP per capita greater than India's GDP per capita.
select name from world where gdp/population > (select gdp/population from world where name= "India" );