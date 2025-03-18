# Script to fill database table with dummy data. Approximately up to 2GB
#!/bin/bash

export PGPASSWORD="my_password"  # Set password

for i in {1..20}  # Run 20 times. This will generate table with nearly 2GB in size
do
    psql -U my_user -d my_local_db -h localhost -p 5432 -c "
        INSERT INTO big_data_table (name, description, random_number, large_blob)
        SELECT
            md5(random()::text),
            repeat(md5(random()::text), 10),
            floor(random() * 100000),
            decode(repeat(md5(random()::text), 20), 'hex')
        FROM generate_series(1, 100000);
    "
    echo "Batch $i inserted..."
done

unset PGPASSWORD  # Remove password after execution
