WITH fi_2021_summary AS (
    SELECT 
		'2021' AS year_,
		country,
		zone_id,
        EXTRACT(MONTH FROM CAST(datetime_utc AS DATE)) AS month_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_direct_carbon_emission,
		ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
		COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_lca_carbon_emission,
		ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
		ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2021_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))
), fi_2022_summary AS (
    SELECT 
		'2022' AS year_,
		country,
		zone_id,
        EXTRACT(MONTH FROM CAST(datetime_utc AS DATE)) AS month_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_direct_carbon_emission,
		ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
		COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_lca_carbon_emission,
		ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
		ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2022_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))
), fi_2023_summary AS (
    SELECT 
		'2023' AS year_,
		country,
		zone_id,
        EXTRACT(MONTH FROM CAST(datetime_utc AS DATE)) AS month_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_direct_carbon_emission,
		ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
		COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_lca_carbon_emission,
		ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
		ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2023_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))
), fi_2024_summary AS (
    SELECT 
		'2024' AS year_,
		country,
		zone_id,
        EXTRACT(MONTH FROM CAST(datetime_utc AS DATE)) AS month_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_direct_carbon_emission,
		ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
		COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (ORDER BY EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))),0) AS next_lca_carbon_emission,
		ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
		ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2023_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM CAST(datetime_utc AS DATE))
), total_summary AS (
	SELECT * FROM fi_2021_summary
	UNION ALL
	SELECT * FROM fi_2022_summary
	UNION ALL
	SELECT * FROM fi_2023_summary
	UNION ALL
	SELECT * FROM fi_2024_summary
)

SELECT 
	year_,
	country,
	zone_id,
    month_grouped,
    total_direct_carbon_emission,
    next_direct_carbon_emission,
    	CASE 
		WHEN next_direct_carbon_emission != 0 AND total_direct_carbon_emission != 0 THEN ROUND(((next_direct_carbon_emission - total_direct_carbon_emission) / total_direct_carbon_emission) * 100::NUMERIC, 2)
		ELSE 0 
	END AS direct_decrease_or_increase,
	total_lca_carbon_emission,
	next_lca_carbon_emission,
        CASE 
		WHEN next_lca_carbon_emission != 0 AND total_lca_carbon_emission != 0 THEN ROUND(((next_lca_carbon_emission - total_lca_carbon_emission) / total_lca_carbon_emission) * 100::NUMERIC, 2)
		ELSE 0 
	END AS lca_decrease_or_increase,
	avg_renewable_percentage,
	avg_low_carbon_percentage
FROM total_summary
ORDER BY year_, month_grouped 


-- HOURLY ANALYSIS

WITH fi_2021_summary AS (
    SELECT 
        '2021' AS year_,
        country,
        zone_id,
        EXTRACT(MONTH FROM datetime_utc) AS month_grouped,
        EXTRACT(HOUR FROM datetime_utc) AS hour_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_direct_carbon_emission,
        ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_lca_carbon_emission,
        ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
        ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2021_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM datetime_utc), EXTRACT(HOUR FROM datetime_utc)
), fi_2022_summary AS (
    SELECT 
        '2022' AS year_,
        country,
        zone_id,
        EXTRACT(MONTH FROM datetime_utc) AS month_grouped,
        EXTRACT(HOUR FROM datetime_utc) AS hour_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_direct_carbon_emission,
        ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_lca_carbon_emission,
        ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
        ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2022_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM datetime_utc), EXTRACT(HOUR FROM datetime_utc)
), fi_2023_summary AS (
    SELECT 
        '2023' AS year_,
        country,
        zone_id,
        EXTRACT(MONTH FROM datetime_utc) AS month_grouped,
        EXTRACT(HOUR FROM datetime_utc) AS hour_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_direct_carbon_emission,
        ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_lca_carbon_emission,
        ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
        ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2023_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM datetime_utc), EXTRACT(HOUR FROM datetime_utc)
), fi_2024_summary AS (
    SELECT 
        '2024' AS year_,
        country,
        zone_id,
        EXTRACT(MONTH FROM datetime_utc) AS month_grouped,
        EXTRACT(HOUR FROM datetime_utc) AS hour_grouped,
        ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2) AS total_direct_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_direct)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_direct_carbon_emission,
        ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2) AS total_lca_carbon_emission,
        COALESCE(LEAD(ROUND(SUM(carbon_intensity_lca)::NUMERIC, 2)) OVER (PARTITION BY EXTRACT(MONTH FROM datetime_utc) ORDER BY EXTRACT(HOUR FROM datetime_utc)), 0) AS next_lca_carbon_emission,
        ROUND((SUM(renewable_percentage)/COUNT(renewable_percentage))::NUMERIC, 2) AS avg_renewable_percentage,
        ROUND((SUM(low_carbon_percentage)/COUNT(low_carbon_percentage))::NUMERIC, 2) AS avg_low_carbon_percentage
    FROM finland.year_2024_hourly
    GROUP BY country, zone_id, EXTRACT(MONTH FROM datetime_utc), EXTRACT(HOUR FROM datetime_utc)
), total_summary AS (
    SELECT * FROM fi_2021_summary
    UNION ALL
    SELECT * FROM fi_2022_summary
    UNION ALL
    SELECT * FROM fi_2023_summary
    UNION ALL
    SELECT * FROM fi_2024_summary
)

SELECT 
    year_,
    country,
    zone_id,
    month_grouped,
    hour_grouped,
    total_direct_carbon_emission,
    next_direct_carbon_emission,
    CASE 
        WHEN next_direct_carbon_emission != 0 AND total_direct_carbon_emission != 0 
            THEN ROUND(((next_direct_carbon_emission - total_direct_carbon_emission) / total_direct_carbon_emission) * 100::NUMERIC, 2)
        ELSE 0 
    END AS direct_decrease_or_increase,
    total_lca_carbon_emission,
    next_lca_carbon_emission,
    CASE 
        WHEN next_lca_carbon_emission != 0 AND total_lca_carbon_emission != 0 
            THEN ROUND(((next_lca_carbon_emission - total_lca_carbon_emission) / total_lca_carbon_emission) * 100::NUMERIC, 2)
        ELSE 0 
    END AS lca_decrease_or_increase,
    avg_renewable_percentage,
    avg_low_carbon_percentage
FROM total_summary
ORDER BY year_, month_grouped, hour_grouped

 