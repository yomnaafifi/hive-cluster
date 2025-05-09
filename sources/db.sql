-- Oracle 11g-Compatible Script for Passengers, Employees, Feedback, and Interactions

-- 1. Table Definitions
CREATE TABLE passengers (
    passenger_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    date_of_birth DATE,
    gender VARCHAR2(10),
    address VARCHAR2(200),
    phone VARCHAR2(15),
    points NUMBER,
    status VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(35),
    date_of_birth DATE,
    gender VARCHAR2(10),
    address VARCHAR2(100),
    phone VARCHAR2(20),
    salary NUMBER(10,2),
    hire_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    is_current CHAR(1) DEFAULT 'Y' CHECK (is_current IN ('Y', 'N')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feedback (
    feedback_id NUMBER PRIMARY KEY,
    type VARCHAR2(50),
    description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_interactions (
    interaction_id NUMBER PRIMARY KEY,
    passenger_id NUMBER,
    employee_id NUMBER,
    feedback_id NUMBER,
    interaction_time TIMESTAMP,
    interaction_date DATE,
    interaction_type VARCHAR2(50),
    satisfaction_rate NUMBER(5,2),
    duration_minutes NUMBER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (feedback_id) REFERENCES feedback(feedback_id)
);

-- 2. Triggers for automatic update of 'modified_at'
CREATE OR REPLACE TRIGGER trg_passengers_modtime
BEFORE UPDATE ON passengers
FOR EACH ROW
BEGIN
  :NEW.modified_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_employees_modtime
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  :NEW.modified_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_feedback_modtime
BEFORE UPDATE ON feedback
FOR EACH ROW
BEGIN
  :NEW.modified_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_interactions_modtime
BEFORE UPDATE ON customer_interactions
FOR EACH ROW
BEGIN
  :NEW.modified_at := CURRENT_TIMESTAMP;
END;
/


-- Passengers table inserts
INSERT INTO passengers (passenger_id, name, date_of_birth, gender, address, phone, points, status)
VALUES 
(31,'Ahmed Hassan', TO_DATE('1990-05-20', 'YYYY-MM-DD'), 'Male', 'Cairo, Egypt', '01012345678', 1200, 'Gold');

INSERT INTO passengers (passenger_id, name, date_of_birth, gender, address, phone, points, status)
VALUES 
(32,'Sara Youssef', TO_DATE('1985-12-11', 'YYYY-MM-DD'), 'Female', 'Giza, Egypt', '01098765432', 800, 'Silver');

INSERT INTO passengers (passenger_id, name, date_of_birth, gender, address, phone, points, status)
VALUES 
(33,'Omar Tarek', TO_DATE('2000-07-30', 'YYYY-MM-DD'), 'Male', 'Alexandria, Egypt', '01111222333', 400, 'Bronze');

-- Employees table inserts
INSERT INTO employees (employee_id, name, date_of_birth, gender, address, phone, salary, hire_date, end_date, is_current)
VALUES 
(51,'Mona Adel', TO_DATE('1980-08-15', 'YYYY-MM-DD'), 'Female', 'Cairo', '01234567890', 8500.00, TO_DATE('2015-01-10', 'YYYY-MM-DD'), NULL, 'Y');

INSERT INTO employees (employee_id, name, date_of_birth, gender, address, phone, salary, hire_date, end_date, is_current)
VALUES 
(52,'Khaled Nabil', TO_DATE('1992-03-05', 'YYYY-MM-DD'), 'Male', 'Giza', '01199887766', 7200.00, TO_DATE('2018-06-01', 'YYYY-MM-DD'), NULL, 'Y');

-- Feedback table inserts
INSERT INTO feedback (feedback_id, type, description)
VALUES 
(101,'Complaint', 'Late response from customer support.');

INSERT INTO feedback (feedback_id, type, description)
VALUES 
(102,'Inquiry', 'Asked about loyalty points policy.');

INSERT INTO feedback (feedback_id, type, description)
VALUES 
(103,'Appreciation', 'Excellent assistance from support staff.');

-- Customer interactions table inserts
INSERT INTO customer_interactions (interaction_id, passenger_id, employee_id, feedback_id, interaction_time, interaction_date, interaction_type, satisfaction_rate, duration_minutes)
VALUES 
(1,31, 51, 101, TO_TIMESTAMP('2025-05-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Phone Call', 3.5, 12);

INSERT INTO customer_interactions (interaction_id, passenger_id, employee_id, feedback_id, interaction_time, interaction_date, interaction_type, satisfaction_rate, duration_minutes)
VALUES 
(2,32, 52, 102, TO_TIMESTAMP('2025-05-02 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-05-02', 'YYYY-MM-DD'), 'Email', 4.8, 5);

INSERT INTO customer_interactions (interaction_id, passenger_id, employee_id, feedback_id, interaction_time, interaction_date, interaction_type, satisfaction_rate, duration_minutes)
VALUES 
(3,33, 51, 103, TO_TIMESTAMP('2025-05-03 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-05-03', 'YYYY-MM-DD'), 'Chat', 5.0, 7);