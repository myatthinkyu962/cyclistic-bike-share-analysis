-- PROCESS STEP 2b: Quantify missing station names
SELECT
  COUNT(*) AS total_rides,
  COUNTIF(start_station_name IS NULL) AS missing_start,
  COUNTIF(end_station_name IS NULL) AS missing_end
FROM `cyclistic.trips_clean`;
