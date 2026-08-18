-- PROCESS STEP 3a: Rides ending before they start
SELECT COUNT(*) AS negative_duration_rides
FROM `cyclistic.trips_clean`
WHERE ended_at < started_at;
