SELECT
	z."Zone",
	SUM(y.total_amount) AS sum_total_amount
FROM
	yellow_taxi_data y
	LEFT JOIN taxi_zone_lookup z ON y."PULocationID" = z."LocationID"
WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
GROUP BY z."Zone"
ORDER BY sum_total_amount DESC
LIMIT 3;