-- PROCESS STEP 1: Verify the twelve monthly files loaded correctly.
-- Expect ~5.85m rides, earliest June 2025, latest May 2026, 2 rider types.
SELECT
  COUNT(*) AS total_rides,
  MIN(started_at) AS earliest,
  MAX(started_at) AS latest,
  COUNT(DISTINCT member_casual) AS rider_types
FROM `cyclistic.trips`;
