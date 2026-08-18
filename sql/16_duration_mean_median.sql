SELECT
  member_casual,
  COUNT(*) AS total_rides,
  AVG(ride_length_secs) AS avg_ride_secs,
  APPROX_QUANTILES(ride_length_secs, 2)[OFFSET(1)] AS median_secs
FROM `cyclistic.trips_final`
GROUP BY member_casual
