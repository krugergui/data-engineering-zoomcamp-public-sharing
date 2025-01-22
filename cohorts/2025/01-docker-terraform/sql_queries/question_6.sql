SELECT
	z."Zone",
	y.tip_amount
FROM
	yellow_taxi_data y
	LEFT JOIN taxi_zone_lookup z ON y."DOLocationID" = z."LocationID"
WHERE y."PULocationID" = (SELECT "LocationID" FROM taxi_zone_lookup WHERE "Zone" = 'East Harlem North')
ORDER BY y.tip_amount DESC
LIMIT 1;