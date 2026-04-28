CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Customer Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE); 
    
    -- products Table
    CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- order items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payment Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

USE ecommerce_db;
INSERT INTO customers VALUES
(1, 'Rahul', 'rahul@gmail.com', 'Delhi', '2023-01-01'),
(2, 'Anita', 'anita@gmail.com', 'Mumbai', '2023-02-15'),
(3, 'John', 'john@gmail.com', 'Bangalore', '2023-03-10');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 50000),
(2, 'Phone', 'Electronics', 20000),
(3, 'Shoes', 'Fashion', 3000);

INSERT INTO orders VALUES
(1, 1, '2023-04-01', 'Completed'),
(2, 2, '2023-04-03', 'Completed'),
(3, 1, '2023-04-05', 'Pending');

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 2, 1);

INSERT INTO payments VALUES
(1, 1, '2023-04-01', 56000, 'UPI'),
(2, 2, '2023-04-03', 20000, 'Card');

-- Total Customers
SELECT * FROM customers;

-- Total revenue
SELECT SUM(amount) FROM payments;

-- Orders per customer
SELECT customer_id,  COUNT(order_id)
FROM orders
GROUP BY customer_id;
USE ecommerce_db;
 
 -- Best Selling Product 
 SELECT pr.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
GROUP BY pr.product_name
ORDER BY total_sold DESC;

-- Monthly Trend Sales
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
SUM(amount) AS revenue
FROM payments
GROUP BY month;

-- Customer Segmentation
SELECT c.name,
CASE 
    WHEN SUM(p.amount) > 50000 THEN 'High Value'
    WHEN SUM(p.amount) BETWEEN 20000 AND 50000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.name;

