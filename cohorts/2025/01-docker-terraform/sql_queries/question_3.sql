CREATE OR REPLACE FUNCTION question_3 ()
RETURNS table (
    range varchar,
    total_trips integer
)
LANGUAGE plpgsql AS $$
DECLARE
    ranges numeric[] := ARRAY[1, 3, 7, 10];
    upper_bound numeric;
    lower_bound numeric;
    upper_bound_index numeric;
BEGIN
    FOR upper_bound_index IN 1..array_length(ranges, 1) + 1 LOOP
        IF upper_bound_index = 1 THEN
            range := 'Up to ' || ranges[upper_bound_index] || ' mile';
            lower_bound := -1;
            upper_bound := ranges[upper_bound_index];
        ELSIF upper_bound_index = array_length(ranges, 1) + 1 THEN
            range := 'Over ' || ranges[upper_bound_index - 1] || ' miles';
            lower_bound := ranges[upper_bound_index - 1];
            upper_bound := '+infinity';
        ELSE
            range := 'In between ' || ranges[upper_bound_index - 1] || ' (exclusive) and ' || ranges[upper_bound_index] || ' miles (inclusive)';
            lower_bound := ranges[upper_bound_index - 1];
            upper_bound := ranges[upper_bound_index];
        END IF;
        SELECT
            COUNT(*) INTO total_trips
        FROM yellow_taxi_data
        WHERE trip_distance <= upper_bound AND trip_distance > lower_bound;
        RETURN NEXT;
	END LOOP;
END; $$;

SELECT * FROM question_3();
