SELECT
 member_casual,
 day_of_week,
 -- ANALYSE 2: Rides and duration by rider type and day of week
CASE day_of_week
  WHEN 1 THEN 'Sun'
  WHEN 2 THEN 'Mon'
  WHEN 3 THEN 'Tue'
  WHEN 4 THEN 'Wed'
  WHEN 5 THEN 'Thur'
  WHEN 6 THEN 'Fri'
  WHEN 7 THEN 'Sat'
END AS day_name,
 COUNT(*) AS total_rides,
 AVG(ride_length_secs) AS avg_ride_secs,
   APPROX_QUANTILES(ride_length_secs, 2)[OFFSET(1)] AS median_secs
FROM`stalwart-city-499414-h4.cyclistic.trips_final`
GROUP BY member_casual, day_of_week
ORDER BY member_casual,day_of_week;
