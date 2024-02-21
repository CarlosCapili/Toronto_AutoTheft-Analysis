-- Where do auto thefts happen the most in 2014?

SELECT
	location_type,
	COUNT(*) AS occurance
FROM auto_theft_open_data
WHERE occ_year = '2014'
GROUP BY location_type
ORDER BY occurance DESC;

-- What location has the highest auto thefts by year?

SELECT
	sub.occ_year,
	sub.location_type,
	sub.theft_occ,
	FIRST_VALUE(sub.location_type) OVER(
		PARTITION BY sub.occ_year
		ORDER BY sub.theft_occ DESC
	) AS high_theft_loc
FROM (
		SELECT
			occ_year,
			location_type,
			COUNT(*) AS theft_occ
		FROM auto_theft_open_data
		WHERE occ_year IS NOT NULL
			AND occ_year >= '2014'
		GROUP BY occ_year, location_type
	) AS sub;

-- Show the progression of theft occurances of the highest theft location by year

SELECT 
	occ_year,
	location_type,
	COUNT(*) AS theft_occ
FROM auto_theft_open_data
WHERE location_type = 'Parking Lots (Apt., Commercial Or Non-Commercial)'
	AND occ_year >= '2014'
GROUP BY occ_year, location_type
ORDER BY occ_year;

-- Comparing the amount of auto theft per year

SELECT
	occ_year,
	COUNT(*) AS auto_theft_occ,
	COUNT(*) - LAG(COUNT(*)) OVER(ORDER BY occ_year) AS auto_theft_diff
FROM auto_theft_open_data
WHERE occ_year >= '2014'
GROUP BY occ_year;

-- What month had the highest thefts for each year?

SELECT 
	occ_year,
	occ_month,
	COUNT(*) AS auto_theft_per_month,
	FIRST_VALUE(occ_month) OVER (
		PARTITION BY occ_year
		ORDER BY COUNT(*) DESC 
	) AS highest_month_theft
FROM auto_theft_open_data
WHERE occ_year >= '2014'
GROUP BY occ_year, occ_month;

WITH monthly_theft AS (
	SELECT 
		occ_year,
		occ_month,
		COUNT(*) AS auto_theft_per_month
	FROM auto_theft_open_data
	WHERE occ_year >= '2014'
	GROUP BY occ_year, occ_month
	ORDER BY occ_year, auto_theft_per_month DESC
)

SELECT DISTINCT
	occ_year,
	FIRST_VALUE(occ_month) OVER (
		PARTITION BY occ_year
	) AS month
FROM monthly_theft

-- What is the average auto theft per month?

WITH monthly_theft AS (
	SELECT 
		occ_year,
		occ_month,
		COUNT(*) AS theft_per_month
	FROM auto_theft_open_data
	WHERE occ_year >= '2014'
	GROUP BY occ_year, occ_month
	ORDER BY occ_year
)

SELECT 
	occ_month as month,
	FLOOR(AVG(theft_per_month)) AS avg_theft_per_month
FROM monthly_theft
GROUP BY occ_month;
	
	




	
	



