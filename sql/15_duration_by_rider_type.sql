-- ANALYSE 1: Ride count and average duration by rider type
SELECT
  member_casual,
  COUNT(*) AS total_rides,
  AVG(ride_length_secs) AS avg_ride_secs
FROM `cyclistic.trips_final`
GROUP BY member_casual;
