-- Active: 1745830860242@@localhost@10000@default
DROP TABLE IF EXISTS fact_customer_feedback;
DROP TABLE IF EXISTS dim_sales_channel;
DROP TABLE IF EXISTS dim_class_of_service;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_time;
DROP TABLE IF EXISTS dim_airport;
DROP TABLE IF EXISTS dim_aircraft;
DROP TABLE IF EXISTS dim_passenger;

CREATE TABLE dim_date (
    date_id INT,
    year INT,
    month INT,
    day_of_month INT,
    day_of_week INT,
    is_holiday STRING,
    is_weekend STRING
)
STORED AS ORC;

CREATE TABLE dim_time (
    time_id INT,
    hour INT,
    minutes INT,
    second INT
)
STORED AS ORC;

CREATE TABLE dim_airport (
    airport_id INT,
    airport_code STRING,
    city STRING,
    country STRING,
    continent STRING,
    longitude DOUBLE,
    latitude DOUBLE,
    time_zone STRING,
    airport_name STRING
)
STORED AS ORC;

CREATE TABLE dim_aircraft (
    aircraft_id INT,
    tail_number STRING,
    manufacturer STRING,
    capacity INT,
    manufacturing_year INT
)
STORED AS ORC;

CREATE TABLE dim_passenger (
    passenger_id INT,
    first_name STRING,
    last_name STRING,
    ssn STRING,
    email STRING,
    phone STRING,
    birth_date DATE
)
STORED AS ORC;

CREATE TABLE dim_class_of_service (
    class_id INT,
    class_type STRING
)
STORED AS ORC;

CREATE TABLE dim_sales_channel (
    channel_id INT,
    channel_type STRING
)
STORED AS ORC;

CREATE TABLE fact_customer_feedback (
    feedback_id INT,
    passenger_id INT,
    time_id INT,
    date_id INT,
    aircraft_id INT,
    origin_airport_id INT,
    destination_airport INT,
    departure_delay_minutes INT,
    arrival_delay_minutes INT,
    class_id INT,
    channel_id INT,
    overall_rating INT,
    review_header STRING,
    recommended STRING,
    seat_comfort INT,
    cabin_staff_service INT,
    ground_service INT,
    value_for_money INT,
    food_beverages INT,
    inflight_entertainment INT,
    wifi_connectivity INT
)
STORED AS ORC;
