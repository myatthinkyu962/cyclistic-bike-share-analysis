-- PROCESS STEP 5: Inspect the 35 duplicate rides found in step 4.
-- Pulls every column for each duplicated ride_id so the pairs can be
-- compared. All 35 proved identical across all thirteen columns and
-- sat on the April/May file boundary, so this is a publishing overlap
-- rather than a data fault.
SELECT * 
FROM `cyclistic.trips`
WHERE ride_id IN (
  -- subquery:the lis of ride_ids that appear more than once 
  SELECT ride_id
  FROM `cyclistic.trips`
  GROUP BY ride_id
  HAVING COUNT(*)>1
)
ORDER BY ride_id; --pairs sit next to each other for comparioson 
