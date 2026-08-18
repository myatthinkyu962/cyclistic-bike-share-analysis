-- PROCESS STEP 5 (revised): Build trips_final
-- Source timestamps are already Chicago local time despite BigQuery
-- displaying them as UTC. Verified against hourly distribution:
-- raw hours show a 3-4am trough and morning/evening peaks.
-- No timezone conversion applied.
SELECT
  *,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_secs,
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
  EXTRACT(HOUR FROM started_at) AS hour_of_day,
  EXTRACT(MONTH FROM started_at) AS month
FROM `cyclistic.trips_clean`
WHERE TIMESTAMP_DIFF(ended_at, started_at, SECOND) >= 30
  AND TIMESTAMP_DIFF(ended_at, started_at, SECOND) <= 86400;
