-- PROCESS STEP 4a: Check EXTRACT behaves as expected before building final table
SELECT
  ride_id,
  started_at,
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
  EXTRACT(HOUR FROM started_at) AS hour_of_day,
  EXTRACT(MONTH FROM started_at) AS month
FROM `cyclistic.trips_clean`
LIMIT 10;
