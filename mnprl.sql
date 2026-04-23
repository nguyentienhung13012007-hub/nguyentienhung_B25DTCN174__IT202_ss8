CREATE DATABASE BookStoreDB;
USE BookStoreDB;


CREATE TABLE Category(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);


CREATE TABLE Book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(10,2),
    category_id INT,
    author_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);


CREATE TABLE BookOrder(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(200) NOT NULL,
    book_id INT NOT NULL,
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CHECK (delivery_date >= order_date)
);

INSERT INTO Category (category_name, description)
VALUES
('IT & Tech','Sách lập trình'),
('Business','Sách kinh doanh'),
('Novel','Tiểu thuyết');

INSERT INTO Book(title,status,publish_date,price,category_id,author_name)
VALUES
('Clean Code',1,'2020-05-10',500000,1,'Robert C.Martin'),
('Đắc Nhân Tâm',0,'2018-08-20',150000,2,'Dale Carnegie'),
('JavaScript Nâng cao',1,'2023-01-15',350000,1,'Kyle Simpson'),
('Nhà Giả Kim',0,'2015-11-25',120000,3,'Paulo Coelho');

INSERT INTO BookOrder(customer_name, book_id, order_date, delivery_date)
VALUES 
('Nguyen Hai Nam',1,'2025-01-10','2025-01-15'),
('Tran Bao Ngoc',3,'2025-02-05','2025-02-10'),
('Le Hoang Yen',4,'2025-03-12',NULL);


UPDATE Book b
JOIN Category c ON b.category_id = c.category_id
SET b.price = b.price + 50000
WHERE c.category_name = 'IT & Tech';


UPDATE BookOrder
SET delivery_date = '2025-12-31'
WHERE delivery_date IS NULL;


DELETE FROM BookOrder
WHERE order_date < '2025-02-01';


SELECT 
    title,
    author_name,
    CASE 
        WHEN status = 1 THEN 'Còn hàng'
        ELSE 'Hết hàng'
    END AS status_name
FROM Book;
SELECT 
    UPPER(title) AS title_upper,
    YEAR(CURDATE()) - YEAR(publish_date) AS years_since_publish
FROM Book;
SELECT 
    b.title,
    b.price,
    c.category_name
FROM Book b
INNER JOIN Category c 
ON b.category_id = c.category_id;
SELECT title, price
FROM Book
ORDER BY price DESC
LIMIT 2;
SELECT 
    c.category_name,
    COUNT(b.book_id) AS total_books
FROM Book b
JOIN Category c ON b.category_id = c.category_id
GROUP BY c.category_name
HAVING COUNT(b.book_id) >= 2;
SELECT *
FROM Book
WHERE price > (SELECT AVG(price) FROM Book);
