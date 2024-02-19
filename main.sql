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
	
	



