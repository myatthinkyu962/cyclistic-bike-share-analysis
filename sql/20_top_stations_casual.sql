-- ANALYSE 5a: Top 10 start stations, casual riders
-- Note: excludes ~21% of rides with no station name (all electric bikes)
SELECT start_station_name,
COUNT(*) AS total_rides
FROM`stalwart-city-499414-h4.cyclistic.trips_final`
WHERE member_casual ='casual' AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY total_rides DESC
LIMIT 10 
