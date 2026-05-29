CREATE DATABASE optimization_lab;
USE optimization_lab;

-- Large orders table (we'll insert 10,000 rows)
-- NO indexes yet — we add them deliberately in case studies
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2),
    city VARCHAR(100)
);

CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    join_date DATE,
    manager_id INT
);

USE optimization_lab;
SHOW VARIABLES LIKE 'cte_max_recursion_depth';
SET SESSION cte_max_recursion_depth = 10000;

-- Insert 10,000 orders
INSERT INTO orders (customer_id, order_status, order_date, total_amount, city)
WITH RECURSIVE gen AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM gen WHERE n < 10000
)
SELECT 
    FLOOR(RAND() * 1000) + 1,
    ELT(FLOOR(RAND() * 4) + 1, 
        'delivered','pending','cancelled','processing'),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 1095) DAY),
    ROUND(RAND() * 5000 + 100, 2),
    ELT(FLOOR(RAND() * 6) + 1, 
        'Mumbai','Delhi','Bangalore','Chennai','Kolkata','Raipur')
FROM gen;

-- Insert 10,000 order items
INSERT INTO order_items (order_id, product_id, quantity, price)
WITH RECURSIVE gen AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM gen WHERE n < 10000
)
SELECT 
    FLOOR(RAND() * 10000) + 1,
    FLOOR(RAND() * 100) + 1,
    FLOOR(RAND() * 5) + 1,
    ROUND(RAND() * 1000 + 50, 2)
FROM gen;

-- Insert 500 employees
INSERT INTO employees (name, department, salary, join_date, manager_id)
WITH RECURSIVE gen AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM gen WHERE n < 500
)
SELECT
    CONCAT('Employee_', n),
    ELT(FLOOR(RAND() * 4) + 1,
        'Engineering','Sales','HR','Finance'),
    ROUND(RAND() * 150000 + 30000, 2),
    DATE(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY)),
    FLOOR(RAND() * 20) + 1
FROM gen;