SELECT
    DATE(lpep_pickup_datetime::date) AS trip_date,
	trip_distance
FROM
    yellow_taxi_data
ORDER BY trip_distance DESC
LIMIT 1;
