-- PROCESS STEP 4b: Check UTC to Chicago local time conversion

SELECT
  started_at,
  DATETIME(started_at, 'America/Chicago') AS started_local
FROM `cyclistic.trips_clean`
LIMIT 10;
