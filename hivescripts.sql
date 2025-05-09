-- 1. Create database (optional)
CREATE DATABASE IF NOT EXISTS customer_care_staging;
USE customer_care_staging;

-- 2. Table Definitions
CREATE TABLE IF NOT EXISTS customer_dim (
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
COMMENT 'Customer dimension table'
STORED AS ORC;

CREATE TABLE IF NOT EXISTS time_dim (
    time_id TIMESTAMP,
    hour INT,
    minute INT,
    hour_description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
COMMENT 'Time dimension table'
STORED AS ORC;

CREATE TABLE IF NOT EXISTS date_dim (
    date_id DATE,
    year INT,
    quarter INT,
    month INT,
    day_of_week INT,
    day_of_month INT,
    day_of_year INT,
    week_of_year INT,
    is_holiday INT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
COMMENT 'Date dimension table'
STORED AS ORC;

CREATE TABLE IF NOT EXISTS feedback_dim (
    feedback_id INT,
    type STRING,
    description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
COMMENT 'Feedback dimension table'
STORED AS ORC;

CREATE TABLE IF NOT EXISTS employee_dim (
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
COMMENT 'Employee dimension table'
STORED AS ORC;

CREATE TABLE IF NOT EXISTS customercarefact (
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
COMMENT 'Customer care fact table'
STORED AS ORC;

show tables;