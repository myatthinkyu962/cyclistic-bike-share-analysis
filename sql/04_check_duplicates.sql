-- PROCESS STEP 1b: Inspect the actual duplicate rows
-- Are the pairs identical (true duplicates) or different rides sharing an ID?
SELECT
  ride_id,
  COUNT(*) AS times_appearing    -- how many rows share this ride_id
FROM `cyclistic.trips`
GROUP BY ride_id
HAVING COUNT(*) > 1              -- keep only IDs appearing more than once
ORDER BY times_appearing DESC;   -- worst offenders first
