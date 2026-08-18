-- PROCESS STEP 3b: Sanity-check the duration calculation
SELECT
CASE
  WHEN TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 15  THEN '0-14 secs'
  WHEN TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 30  THEN '15-29 secs'
  WHEN TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 60  THEN '30-59 secs'
  WHEN TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 120 THEN '60-119 secs'
  WHEN TIMESTAMP_DIFF(ended_at, started_at, SECOND) < 300 THEN '120-299 secs'
  ELSE '300+ secs'
END AS duration_band,
MIN(TIMESTAMP_DIFF(ended_at, started_at, SECOND))AS band_floor,
COUNT(*) AS rides
FROM `cyclistic.trips_clean`
GROUP BY duration_band
ORDER BY band_floor;
