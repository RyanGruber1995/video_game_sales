# Count number of rows that have year as 'N/A'
SELECT COUNT(*)
FROM vgsales.games
WHERE year = "N/A"


# Delete rows where year is unknown
DELETE FROM vgsales.games WHERE year = "N/A"


# Count games from each year
SELECT 
  year,
  COUNT(*) AS num_of_games
FROM vgsales.games
GROUP BY year
ORDER BY year ASC


# Get the games that were "released" in 2017 and 2020
SELECT 
    name,
    year
FROM vgsales.games
WHERE year = 2017 OR year = 2020


# Update years for games in 2017 and 2020
UPDATE vgsales.games
SET year = 2009
WHERE name = "Imagine: Makeup Artist"

UPDATE vgsales.games
SET year = 2007
WHERE name = "Phantasy Star Online 2 Episode 4: Deluxe Package"

UPDATE vgsales.games
SET year = 2016
WHERE name = "Brothers Conflict: Precious Baby"


# Find duplicate names and number of occurences
SELECT
  DISTINCT name,
  COUNT(name) AS num_instances
FROM vgsales.games
GROUP BY name
HAVING num_instances > 1


# Find unique records
SELECT DISTINCT *
FROM vgsales.games


# Categorize Nintendo games
SELECT
  name,
  CASE
    WHEN name LIKE '%Mario%' THEN 'Mario'
    WHEN name LIKE '%Pok%mon%' THEN 'Pokemon'
    WHEN name LIKE '%Zelda%' THEN 'Zelda'
    WHEN name LIKE '%Donkey Kong%' THEN 'Donkey Kong'
    WHEN name LIKE '%Kirby%' THEN 'Kirby'
    WHEN name LIKE '%Metroid%' THEN 'Metroid'
    WHEN name LIKE '%Animal Crossing%' THEN 'Animal Crossing'
    ELSE 'Other'
  END AS game_series
FROM vgsales.games g JOIN vgsales.publisher p ON g.publisher_id = p.publisher_id
WHERE p.publisher_name = 'Nintendo'
ORDER BY game_id ASC


# Sort game series by sales
SELECT
  CASE
    WHEN name LIKE '%Mario%' THEN 'Mario'
    WHEN name LIKE '%Pok%mon%' THEN 'Pokemon'
    WHEN name LIKE '%Zelda%' THEN 'Zelda'
    WHEN name LIKE '%Donkey Kong%' THEN 'Donkey Kong'
    WHEN name LIKE '%Kirby%' THEN 'Kirby'
    WHEN name LIKE '%Metroid%' THEN 'Metroid'
    WHEN name LIKE '%Animal Crossing%' THEN 'Animal Crossing'
    ELSE "Other"
  END AS game_series,
  ROUND(SUM(Global_Sales),2) AS total_sales_millions
FROM vgsales.games
GROUP BY game_series
HAVING game_series != 'Other'
ORDER BY total_sales_millions DESC


# Compare sales of handheld vs console Pokemon games
SELECT
  CASE
    WHEN platform_name IN ('GB', 'GBA', 'DS', '3DS') THEN 'Handheld'
    ELSE 'Console'
  END AS device,
  ROUND(SUM(Global_Sales), 2) AS total_sales_millions,
  ROUND(AVG(Global_Sales), 2) AS average_sales_millions
FROM vgsales.games g JOIN vgsales.platform p ON g.platform_id = p.platform_id
WHERE name LIKE '%Pok%mon%'
GROUP BY device


#Group main series Pokemon games by platform
WITH main_series_games AS ( -- create a main_series variable to filter later
SELECT *,
  CASE WHEN name IN 
    (
      'Pokemon Red/Pokemon Blue',
      'Pokemon Gold/Pokemon Silver',
      'Pokemon Diamond/Pokemon Pearl',
      'Pokemon Ruby/Pokemon Sapphire',
      'Pokemon Black/Pokemon White',
      'Pokémon Yellow: Special Pikachu Edition',
      'Pokemon X/Pokemon Y',
      'Pokemon HeartGold/Pokemon SoulSilver',
      'Pokemon Omega Ruby/Pokemon Alpha Sapphire',
      'Pokemon FireRed/Pokemon LeafGreen',
      'Pokemon Black 2/Pokemon White 2',
      'Pokémon Platinum Version',
      'Pokémon Emerald Version',
      'Pokémon Crystal Version'
    ) THEN 1
    ELSE 0
  END AS main_series
FROM vgsales.games g JOIN vgsales.platform p ON g.platform_id = p.platform_id
)
SELECT -- create a table with relevant columns, filter for main series games, first partitioning by platform, and then sorting by year
  game_id,
  name,
  platform_name,
  year,
  Global_Sales 
FROM main_series_games
WHERE main_series = 1
ORDER BY platform_name ASC, year ASC