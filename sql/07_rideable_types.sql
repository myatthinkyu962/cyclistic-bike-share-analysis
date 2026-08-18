SELECT
  rideable_type,
  COUNT(*) AS total_rides
FROM `cyclistic.trips_clean`
GROUP BY rideable_type
ORDER BY total_rides DESC;
