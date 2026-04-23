CREATE DATABASE SalesManagement;
USE SalesManagement;

-- Customer
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    gender BOOLEAN, -- 1: Nam, 0: Nữ
    birth_date DATE
);

-- Category
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Product
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Order Detail
CREATE TABLE Order_Detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Category
INSERT INTO Category (category_name) VALUES
('Điện tử'), ('Thời trang'), ('Gia dụng'), ('Sách'), ('Thể thao');

-- Customer
INSERT INTO Customer (full_name, email, gender, birth_date) VALUES
('Nguyễn Văn A', 'a@gmail.com', 1, '2000-01-01'),
('Trần Thị B', 'b@gmail.com', 0, '1998-05-10'),
('Lê Văn C', 'c@gmail.com', 1, '2002-03-15'),
('Phạm Thị D', 'd@gmail.com', 0, '1995-07-20'),
('Hoàng Văn E', 'e@gmail.com', 1, '2001-09-09');

-- Product
INSERT INTO Product (product_name, price, category_id) VALUES
('Laptop', 1500, 1),
('Điện thoại', 800, 1),
('Áo', 50, 2),
('Nồi cơm', 120, 3),
('Sách SQL', 30, 4);

-- Orders
INSERT INTO Orders (customer_id) VALUES
(1), (2), (1), (3), (4);

-- Order Detail
INSERT INTO Order_Detail (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1500),
(1, 3, 2, 50),
(2, 2, 1, 800),
(3, 5, 3, 30),
(4, 4, 1, 120);
-- Cập nhật giá sản phẩm
UPDATE Product
SET price = 1600
WHERE product_name = 'Laptop';

-- Cập nhật email khách hàng
UPDATE Customer
SET email = 'newemail@gmail.com'
WHERE customer_id = 1;
DELETE FROM Order_Detail
WHERE order_detail_id = 5;
SELECT 
    full_name AS 'Họ tên',
    email AS 'Email',
    CASE 
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Giới tính'
FROM Customer;
SELECT *,
       YEAR(NOW()) - YEAR(birth_date) AS age
FROM Customer
ORDER BY age ASC
LIMIT 3;
SELECT o.order_id, c.full_name, o.order_date
FROM Orders o
INNER JOIN Customer c ON o.customer_id = c.customer_id;
SELECT category_id, COUNT(*) AS total_products
FROM Product
GROUP BY category_id
HAVING COUNT(*) >= 2;
SELECT *
FROM Product
WHERE price > (SELECT AVG(price) FROM Product);
SELECT *
FROM Customer
WHERE customer_id NOT IN (
    SELECT customer_id FROM Orders
);
SELECT category_id, SUM(od.quantity * od.price) AS revenue
FROM Order_Detail od
JOIN Product p ON od.product_id = p.product_id
GROUP BY category_id
HAVING revenue > (
    SELECT AVG(total_rev) * 1.2
    FROM (
        SELECT SUM(quantity * price) AS total_rev
        FROM Order_Detail
        GROUP BY order_id
    ) t
);
SELECT *
FROM Product p1
WHERE price = (
    SELECT MAX(price)
    FROM Product p2
    WHERE p1.category_id = p2.category_id
);
SELECT full_name
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE order_id IN (
        SELECT order_id
        FROM Order_Detail
        WHERE product_id IN (
            SELECT product_id
            FROM Product
            WHERE category_id = (
                SELECT category_id
                FROM Category
                WHERE category_name = 'Điện tử'
            )
        )
    )
);