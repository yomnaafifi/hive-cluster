--employee dimension table
-- employee_id is bucketed for efficient joins with facts.
-- Partitioned by gender (usually small cardinality: Male/Female/Other — safe).
-- Using ORC format for transaction support.

CREATE TABLE employee_dim (
    employee_id INT,
    employee_name STRING,
    employee_dateOfBirth DATE,
    employee_gender STRING,
    employee_address STRING,
    employee_phone STRING,
    salary DOUBLE,
    start_date DATE,      -- for SCD2 tracking
    end_date DATE,        -- for SCD2 tracking
    is_current BOOLEAN    -- for SCD2 tracking
)
PARTITIONED BY (employee_gender STRING)   -- because gender will not create too many partitions
CLUSTERED BY (employee_id) INTO 8 BUCKETS  -- better for joins
STORED AS ORC
TBLPROPERTIES (
    'transactional'='true'
);

----------------------------------------------------------------------

--feedback dimension table
-- Small dimension → no partitioning needed.
-- Bucket by feedback_id for optimized joins.
-- Make it transactional for possible future updates

CREATE TABLE feedback_dim (
    feedback_id INT,
    type STRING,
    description STRING
)
CLUSTERED BY (feedback_id) INTO 4 BUCKETS
STORED AS ORC
TBLPROPERTIES (
    'transactional'='true'
);


----------------------------------------------------------------------
--date dimension table
CREATE TABLE date_dim (
    date_id INT,
    year INT,
    quarter INT,
    month INT,
    day_of_week STRING,
    day_of_month INT,
    day_of_year INT,
    week_of_year INT,
    is_holiday BOOLEAN
)
STORED AS ORC;


----------------------------------------------------------------------
--time dimension table
CREATE TABLE time_dim (
    time_id INT,
    hour INT,
    minutes INT,
    hour_description STRING
)
STORED AS ORC;

----------------------------------------------------------------------
--fact table

CREATE TABLE customer_care_fact (
    customer_id BIGINT,
    date_id INT,
    time_id INT,
    feedback_id INT,
    employee_id INT,
    interaction_type STRING,
    satisfaction_rate DOUBLE,
    duration INT
)
PARTITIONED BY (date_id INT)
CLUSTERED BY (customer_id) INTO 16 BUCKETS
STORED AS ORC
TBLPROPERTIES (
    'transactional'='true'
);

