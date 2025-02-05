Here's how to arrive in all the solutions using these files:

1. `docker-compose up` to start the containers
2. `psql -U kestra -d postgres -h localhost -f create_zoomcamp_db.sql` to create the database (use the password `k3str4`)
3. `curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/02_postgres_taxi_scheduled.yaml` to import the flow
4. Open the kestra UI at http://localhost:8080
5. Open flows, select the flow you just imported
6. On the top bar select "Triggers" and for each trigger, click the "Backfill executions" button
7. For each trigger, select the date range (2020-01-01 to 2021-12-31) and click "Execute backfill"
8. Wait for the backfill to finish, you can check the progress in the "Executions" tab
9. For answer 1. go to logs, filter for "yellow_tripdata_2020-12.csv" and check the output
10. Answer 2. can be deducted from the output of answer 1
11. Answer 3. to 5. execute the command `psql -U kestra -d postgres -h localhost -f Questions_3-5.sql`
12. Answer 6. check the official documentation at https://kestra.io/docs/workflow-components/triggers/schedule-trigger
