

  -- ANALYSE 2: Rides and duration by rider type and month
-- ANALYSE 4: Rides and duration by rider type and month
SELECT
  member_casual,
  month,
  CASE month
    WHEN 1 THEN 'Jan'  WHEN 2 THEN 'Feb'  WHEN 3 THEN 'Mar'
    WHEN 4 THEN 'Apr'  WHEN 5 THEN 'May'  WHEN 6 THEN 'Jun'
    WHEN 7 THEN 'Jul'  WHEN 8 THEN 'Aug'  WHEN 9 THEN 'Sep'
    WHEN 10 THEN 'Oct' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Dec'
  END AS month_name,
  CASE month
    WHEN 6 THEN 1   WHEN 7 THEN 2   WHEN 8 THEN 3
    WHEN 9 THEN 4   WHEN 10 THEN 5  WHEN 11 THEN 6
    WHEN 12 THEN 7  WHEN 1 THEN 8   WHEN 2 THEN 9
    WHEN 3 THEN 10  WHEN 4 THEN 11  WHEN 5 THEN 12
  END AS sort_order,
  COUNT(*) AS total_rides,
  AVG(ride_length_secs) AS avg_ride_secs,
  APPROX_QUANTILES(ride_length_secs, 2)[OFFSET(1)] AS median_secs
FROM `cyclistic.trips_final`
GROUP BY member_casual, month
ORDER BY member_casual, sort_order;
 
