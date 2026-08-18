--Combine them into one query returning, for each bike type: total rides, and how many are missing a start station name.
-- PROCESS STEP 2b: Quantify missing station names
SELECT
  rideable_type,
  COUNT(*) AS total_rides,
  COUNTIF(start_station_name IS NULL) AS missing_start,
  COUNTIF(end_station_name IS NULL) AS missing_end
FROM `cyclistic.trips_clean`
GROUP BY rideable_type
ORDER BY total_rides DESC;
