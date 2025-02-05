SELECT 'Q3 - Yellow 2020' as Question,  count(*) FROM yellow_tripdata
WHERE filename LIKE('%yellow_tripdata_2020%')

UNION ALL

SELECT 'Q4 - Green 2020' as Question,  count(*) FROM green_tripdata
WHERE filename LIKE('%green_tripdata_2020%')

UNION ALL

SELECT 'Q5 - Yellow March 2021' as Question,  count(*) FROM yellow_tripdata
WHERE filename LIKE('%yellow_tripdata_2021-03%')
ORDER BY Question
