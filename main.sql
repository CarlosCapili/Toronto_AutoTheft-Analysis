-- Where do auto thefts happen in 2014?
-- SELECT
-- 	location_type,
-- 	COUNT(*) AS thefts
-- FROM auto_theft_open_data
-- WHERE occ_year = '2014'
-- GROUP BY location_type
-- ORDER BY thefts DESC;

-- Where do auto thefts happen per year?
-- SELECT DISTINCT
-- 	occ_year,
-- 	location_type,
-- 	COUNT(*) OVER(PARTITION BY occ_year, location_type) AS thefts
-- FROM auto_theft_open_data
-- WHERE occ_year >= 2014
-- ORDER BY occ_year, thefts DESC;

-- What location has the highest auto thefts per year?
WITH ordered_theft_loc AS (
	SELECT
		occ_year,
		location_type,
		COUNT(*) AS thefts,
		ROW_NUMBER() OVER(PARTITION BY occ_year ORDER BY COUNT(*) DESC) AS rn
	FROM auto_theft_open_data
	WHERE occ_year >= 2014
	GROUP BY occ_year, location_type
	ORDER BY occ_year, thefts DESC
)

SELECT 
	occ_year,
	location_type,
	thefts
FROM ordered_theft_loc
WHERE rn = 1;

-- -- Show the progression of theft occurances of the highest theft location by year

-- SELECT 
-- 	occ_year,
-- 	location_type,
-- 	COUNT(*) AS theft_occ
-- FROM auto_theft_open_data
-- WHERE location_type = 'Parking Lots (Apt., Commercial Or Non-Commercial)'
-- 	AND occ_year >= '2014'
-- GROUP BY occ_year, location_type
-- ORDER BY occ_year;

-- -- Comparing the amount of auto theft per year

-- SELECT
-- 	occ_year,
-- 	COUNT(*) AS auto_theft_occ,
-- 	COUNT(*) - LAG(COUNT(*)) OVER(ORDER BY occ_year) AS auto_theft_diff
-- FROM auto_theft_open_data
-- WHERE occ_year >= '2014'
-- GROUP BY occ_year;

-- -- What month had the highest thefts for each year?

-- SELECT 
-- 	occ_year,
-- 	occ_month,
-- 	COUNT(*) AS auto_theft_per_month,
-- 	FIRST_VALUE(occ_month) OVER (
-- 		PARTITION BY occ_year
-- 		ORDER BY COUNT(*) DESC 
-- 	) AS highest_month_theft
-- FROM auto_theft_open_data
-- WHERE occ_year >= '2014'
-- GROUP BY occ_year, occ_month;

-- WITH monthly_theft AS (
-- 	SELECT 
-- 		occ_year,
-- 		occ_month,
-- 		COUNT(*) AS auto_theft_per_month
-- 	FROM auto_theft_open_data
-- 	WHERE occ_year >= '2014'
-- 	GROUP BY occ_year, occ_month
-- 	ORDER BY occ_year, auto_theft_per_month DESC
-- )

-- SELECT DISTINCT
-- 	occ_year,
-- 	FIRST_VALUE(occ_month) OVER (
-- 		PARTITION BY occ_year
-- 	) AS month
-- FROM monthly_theft

-- -- What is the average auto theft per month?

-- WITH monthly_theft AS (
-- 	SELECT 
-- 		occ_year,
-- 		occ_month,
-- 		COUNT(*) AS theft_per_month
-- 	FROM auto_theft_open_data
-- 	WHERE occ_year >= '2014'
-- 	GROUP BY occ_year, occ_month
-- 	ORDER BY occ_year
-- )

-- SELECT 
-- 	occ_month as month,
-- 	FLOOR(AVG(theft_per_month)) AS avg_theft_per_month
-- FROM monthly_theft
-- GROUP BY occ_month;
	
	




	
	



