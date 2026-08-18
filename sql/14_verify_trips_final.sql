-- Verify trips_final built correctly
SELECT
COUNT(*) AS total_rides,
MIN(ride_length_secs) AS shortest,
MAX(ride_length_secs) AS longest
FROM `stalwart-city-499414-h4.cyclistic.trips_final`;
