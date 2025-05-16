-- Active: 1745830860242@@localhost@10000@defaultmydwh
CREATE DATABASE IF NOT EXISTS customer_care_staging;
USE customer_care_staging;
-- Customer Dimension
CREATE EXTERNAL TABLE customer_dim (
    sk_passenger_id INT,
    passenger_id INT,
    passenger_name STRING,
    passenger_dateofbirth DATE,
    passenger_gender STRING,
    passenger_address STRING,
    passenger_phone STRING,
    passenger_points INT,
    passenger_status STRING,
    start_date DATE,
    end_date DATE,
    is_current STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/customer_dim';

-- Time Dimension
CREATE EXTERNAL TABLE time_dim (
    time_id TIMESTAMP,
    hour SMALLINT,
    minute SMALLINT,
    hour_description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/time_dim';

-- Date Dimension
CREATE EXTERNAL TABLE date_dim (
    date_id DATE,
    year INT,
    quarter SMALLINT,
    month SMALLINT,
    day_of_week SMALLINT,
    day_of_month SMALLINT,
    day_of_year SMALLINT,
    week_of_year SMALLINT,
    is_holiday SMALLINT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/date_dim';

-- Feedback Dimension
CREATE EXTERNAL TABLE feedback_dim (
    feedback_id INT,
    type STRING,
    description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/feedback_dim';

-- Employee Dimension
CREATE EXTERNAL TABLE employee_dim (
    sk_employee_id INT,
    employee_id INT,
    employee_name STRING,
    employee_dateofbirth DATE,
    employee_gender STRING,
    employee_address STRING,
    employee_phone STRING,
    salary DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    is_current STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/employee_dim';

-- Customer Care Fact Table
CREATE EXTERNAL TABLE customercarefact (
    customer_id INT,
    date_id DATE,
    time_id TIMESTAMP,
    feedback_id INT,
    employee_id INT,
    interaction_type STRING,
    satisfaction_rate DECIMAL(5,2),
    duration INT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/customer_care_staging/customercarefact';


show tables;

select * from customer_care_staging.customer_dim;