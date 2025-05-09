-- 1. Sequences for auto-increment fields
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE feedback_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE employee_seq START WITH 1 INCREMENT BY 1;

-- 2. Table Definitions
CREATE TABLE customer_dim (
    sk_passenger_id NUMBER PRIMARY KEY,
    passenger_id NUMBER,
    passenger_name VARCHAR2(100),
    passenger_dateofbirth DATE,
    passenger_gender VARCHAR2(10),
    passenger_address VARCHAR2(200),
    passenger_phone VARCHAR2(15),
    passenger_points NUMBER,
    passenger_status VARCHAR2(50),
    start_date DATE DEFAULT TO_DATE('2000-01-01','YYYY-MM-DD'),
    end_date DATE DEFAULT TO_DATE('9999-12-31','YYYY-MM-DD'),
    is_current CHAR(1) DEFAULT 'Y' CHECK (is_current IN ('Y', 'N')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE time_dim (
    time_id TIMESTAMP PRIMARY KEY,
    hour NUMBER(2) NOT NULL,
    minute NUMBER(2) NOT NULL,
    hour_description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE date_dim (
    date_id DATE PRIMARY KEY,
    year NUMBER,
    quarter NUMBER(1),
    month NUMBER(2),
    day_of_week NUMBER(1),
    day_of_month NUMBER(2),
    day_of_year NUMBER(3),
    week_of_year NUMBER(2),
    is_holiday NUMBER(1) CHECK (is_holiday IN (0,1)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feedback_dim (
    feedback_id NUMBER PRIMARY KEY,
    type VARCHAR2(50),
    description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_dim (
    sk_employee_id NUMBER PRIMARY KEY,
    employee_id NUMBER,
    employee_name VARCHAR2(35),
    employee_dateofbirth DATE,
    employee_gender VARCHAR2(10),
    employee_address VARCHAR2(100),
    employee_phone VARCHAR2(20),
    salary NUMBER(10,2),
    start_date DATE DEFAULT SYSDATE,
    end_date DATE,
    is_current CHAR(1) DEFAULT 'Y' CHECK (is_current IN ('Y', 'N')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customercarefact (
    customer_id NUMBER,
    date_id DATE,
    time_id TIMESTAMP,
    feedback_id NUMBER,
    employee_id NUMBER,
    interaction_type VARCHAR2(50),
    satisfaction_rate NUMBER(5,2),
    duration NUMBER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_customer_care PRIMARY KEY (customer_id, date_id, feedback_id, employee_id, time_id),
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customer_dim(sk_passenger_id),
    CONSTRAINT fk_care_date FOREIGN KEY (date_id) REFERENCES date_dim(date_id),
    CONSTRAINT fk_care_feedback FOREIGN KEY (feedback_id) REFERENCES feedback_dim(feedback_id),
    CONSTRAINT fk_care_employee FOREIGN KEY (employee_id) REFERENCES employee_dim(sk_employee_id),
    CONSTRAINT fk_care_time FOREIGN KEY (time_id) REFERENCES time_dim(time_id)
);

-- 3. Triggers for auto-incrementing IDs
CREATE OR REPLACE TRIGGER trg_customer_bi
BEFORE INSERT ON customer_dim
FOR EACH ROW
BEGIN
    SELECT customer_seq.NEXTVAL INTO :NEW.sk_passenger_id FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_feedback_bi
BEFORE INSERT ON feedback_dim
FOR EACH ROW
BEGIN
    SELECT feedback_seq.NEXTVAL INTO :NEW.feedback_id FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_employee_bi
BEFORE INSERT ON employee_dim
FOR EACH ROW
BEGIN
    SELECT employee_seq.NEXTVAL INTO :NEW.sk_employee_id FROM dual;
END;
/


-- 4. Generate time_dim data with PL/SQL (alternative to generate_series)
BEGIN
  FOR i IN 0..47 LOOP
    INSERT INTO time_dim (time_id, hour, minute, hour_description)
    VALUES (
      TIMESTAMP '2020-01-01 00:00:00' + i * INTERVAL '30' MINUTE,
      MOD(TRUNC(i / 2), 24),
      CASE MOD(i, 2) WHEN 0 THEN 0 ELSE 30 END,
      CASE
        WHEN MOD(TRUNC(i / 2), 24) = 0 THEN 'Midnight'
        WHEN MOD(TRUNC(i / 2), 24) BETWEEN 1 AND 5 THEN 'Early Morning'
        WHEN MOD(TRUNC(i / 2), 24) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN MOD(TRUNC(i / 2), 24) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN MOD(TRUNC(i / 2), 24) BETWEEN 18 AND 20 THEN 'Evening'
        ELSE 'Night'
      END
    );
  END LOOP;
  COMMIT;
END;
/
