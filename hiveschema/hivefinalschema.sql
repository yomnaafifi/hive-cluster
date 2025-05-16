Set hive.support.concurrency = true;
Set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
set hive.compactor.initiator.on = true;
set hive.compactor.worker.threads =1;


-- Use final database
CREATE DATABASE IF NOT EXISTS CustomerCare;
USE CustomerCare;

-- Customer Dimension
CREATE TABLE customer_dim (
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
CLUSTERED BY (passenger_id) INTO 8 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

INSERT INTO TABLE CustomerCare.customer_dim
SELECT * FROM customer_care_staging.customer_dim;



-- Employee Dimension
CREATE TABLE employee_dim (
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
CLUSTERED BY (employee_id) INTO 8 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

INSERT INTO TABLE CustomerCare.employee_dim
SELECT * FROM customer_care_staging.employee_dim;

-- Date Dimension
CREATE EXTERNAL TABLE time_dim (
    time_id TIMESTAMP,
    hour SMALLINT,
    minute SMALLINT,
    hour_description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
STORED AS ORC
LOCATION '/user/hive/warehouse/CustomerCare/time_dim';

INSERT INTO TABLE CustomerCare.time_dim
SELECT * FROM customer_care_staging.time_dim;

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
STORED AS ORC
LOCATION '/user/hive/warehouse/CustomerCare/date_dim';


INSERT INTO TABLE CustomerCare.date_dim
SELECT * FROM customer_care_staging.date_dim;

-- External Table: Feedback Dimension
CREATE EXTERNAL TABLE feedback_dim (
    feedback_id INT,
    type STRING,
    description STRING,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
STORED AS ORC
LOCATION '/user/hive/warehouse/CustomerCare/feedback_dim';

INSERT INTO TABLE CustomerCare.feedback_dim
SELECT * FROM customer_care_staging.feedback_dim;

-- Fact Table: Customer Care Fact (Partitioned and Bucketed)
CREATE EXTERNAL TABLE customercarefact (
    customer_id INT,
    date_id DATE,
    time_id TIMESTAMP,
    feedback_id INT,
    employee_id INT,
    satisfaction_rate DECIMAL(5,2),
    duration INT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP
)
PARTITIONED BY (interaction_type STRING)
CLUSTERED BY (customer_id) INTO 8 BUCKETS
STORED AS ORC
LOCATION '/user/hive/warehouse/CustomerCare/customercarefact' 

INSERT INTO TABLE CustomerCare.customercarefact
PARTITION (interaction_type = 'In-person')
SELECT 
    customer_id,
    date_id,
    time_id,
    feedback_id,
    employee_id,
    satisfaction_rate,
    duration,
    created_at,
    modified_at
FROM customer_care_staging.customercarefact
WHERE interaction_type = 'In-person';

INSERT INTO TABLE CustomerCare.customercarefact
PARTITION (interaction_type = 'Chat')
SELECT 
    customer_id,
    date_id,
    time_id,
    feedback_id,
    employee_id,
    satisfaction_rate,
    duration,
    created_at,
    modified_at
FROM customer_care_staging.customercarefact
WHERE interaction_type = 'Chat';


show tables;

select * from CustomerCarecustomer_dim;
