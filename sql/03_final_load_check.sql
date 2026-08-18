-- PROCESS STEP 3: Final load check after all twelve files are in,
-- Comparing total rides against distinct ride_ids tests for duplicates:
-- a gap between the two means some rides were loaded twice
SELECT
  COUNT(*) AS total_rides,
  COUNT(DISTINCT ride_id) AS unique_rides,
  COUNT(DISTINCT member_casual) AS rider_types,
  MIN(started_at) AS earliest,
  MAX(started_at) AS latest
FROM `cyclistic.trips`;
