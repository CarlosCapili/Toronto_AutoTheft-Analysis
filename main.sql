-- What are the total amount of auto thefts per year
SELECT 
	occ_year,
	COUNT(*) AS thefts
FROM auto_theft_open_data
WHERE occ_year >= 2014
GROUP BY occ_year
ORDER BY occ_year;

-- Where do auto thefts happen in 2014?
SELECT
	location_type,
	COUNT(*) AS thefts
FROM auto_theft_open_data
WHERE occ_year = '2014'
GROUP BY location_type
ORDER BY thefts DESC;

-- Where do auto thefts happen per year?
SELECT DISTINCT
	occ_year,
	location_type,
	COUNT(*) OVER(PARTITION BY occ_year, location_type) AS thefts
FROM auto_theft_open_data
WHERE occ_year >= 2014
ORDER BY occ_year, thefts DESC;

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

-- Show the increase/decrease percentage of auto thefts in parking lots per year
WITH theft_diff AS (
	SELECT 
		occ_year,
		location_type,
		COUNT(*) AS thefts,
		LAG(COUNT(*)) OVER(ORDER BY occ_year) AS prev_thefts,
		COUNT(*) - LAG(COUNT(*)) OVER(ORDER BY occ_year) AS difference
	FROM auto_theft_open_data
	WHERE location_type = 'Parking Lots (Apt., Commercial Or Non-Commercial)'
		AND occ_year >= 2014
	GROUP BY occ_year, location_type
	ORDER BY occ_year
)

SELECT
	occ_year,
	location_type,
	thefts,
	CASE
		WHEN difference < 0 THEN CONCAT(ROUND(ABS(difference)::numeric / prev_thefts * 100.0, 2), '% decrease')
		WHEN difference > 0 THEN CONCAT(ROUND(ABS(difference)::numeric / prev_thefts * 100.0, 2), '% increase')
		ELSE 'No change'
	END AS pct_inc_dec
FROM theft_diff;

-- How many thefts happen per month per year?
SELECT 
	occ_year,
	occ_month,
	COUNT(*) AS theft_per_month
FROM auto_theft_open_data
WHERE occ_year >= 2014
GROUP BY occ_year, occ_month
ORDER BY occ_year, theft_per_month DESC;

-- How many thefts happen per day per month for each year?
SELECT
	occ_year,
	occ_month,
	occ_dow,
	COUNT(*) AS thefts
FROM auto_theft_open_data
WHERE occ_year >= '2014'
GROUP BY occ_year, occ_month, occ_dow
ORDER BY occ_year, occ_month;

-- How many thefts happen for each day of the week for each year?
SELECT
	occ_year,
	occ_dow,
	COUNT(*) AS thefts
FROM auto_theft_open_data
WHERE occ_year >= '2014'
GROUP BY occ_year, occ_dow
ORDER BY occ_year, occ_dow;

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
	occ_month,
	FLOOR(AVG(theft_per_month)) AS avg_theft_per_month
FROM monthly_theft
GROUP BY occ_month;

-- Show the month with the highest theft and lowest theft per year
WITH numbered_monthly_theft AS (
	SELECT 
		occ_year,
		occ_month,
		COUNT(*) AS theft_per_month,
		ROW_NUMBER() OVER(PARTITION BY occ_year ORDER BY COUNT(*) DESC) AS rn_desc,
		ROW_NUMBER() OVER(PARTITION BY occ_year ORDER BY COUNT(*)) AS rn_asc
	FROM auto_theft_open_data
	WHERE occ_year >= '2014'
	GROUP BY occ_year, occ_month
	ORDER BY occ_year, theft_per_month DESC
)

SELECT 
	occ_year,
	MAX(CASE WHEN rn_desc = 1 THEN occ_month END) AS most_theft,
	MAX(CASE WHEN rn_desc = 1 THEN theft_per_month END) AS most_theft_amt,
	MAX(CASE WHEN rn_asc = 1 THEN occ_month END) AS least_theft,
	MAX(CASE WHEN rn_asc = 1 THEN theft_per_month END) AS least_theft_amt
FROM numbered_monthly_theft
GROUP BY occ_year;


	
	



	
	



