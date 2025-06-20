-- Tạo database
CREATE DATABASE ngay_2;
USE ngay_2;
SHOW TABLES;

-- Bảng Users
CREATE TABLE ngay_2.Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    city VARCHAR(100),
    referrer_id INT,
    created_at DATE,
    FOREIGN KEY (referrer_id) REFERENCES Users(user_id)
);

-- Bảng Products
CREATE TABLE ngay_2.Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price INT,
    is_active BOOLEAN
);


-- Bảng Orders
CREATE TABLE ngay_2.Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Bảng OrderItems
CREATE TABLE ngay_2.OrderItems (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Thêm dữ liệu mẫu vào bảng Users
INSERT INTO ngay_2.Users (user_id, full_name, city, referrer_id, created_at) VALUES
(1, 'Nguyen Van A', 'Hanoi', NULL, '2023-01-01'),
(2, 'Tran Thi B', 'HCM', 1, '2023-01-10'),
(3, 'Le Van C', 'Hanoi', 1, '2023-01-12'),
(4, 'Do Thi D', 'Da Nang', 2, '2023-02-05'),
(5, 'Hoang E', 'Can Tho', NULL, '2023-02-10');

-- Thêm dữ liệu mẫu vào bảng Products
INSERT INTO ngay_2.Products (product_id, product_name, category, price, is_active) VALUES
(1, 'iPhone 13', 'Electronics', 20000000, 0),
(2, 'MacBook Air', 'Electronics', 28000000, 1),
(3, 'Coffee Beans', 'Grocery', 250000, 1),
(4, 'Book: SQL Basics', 'Books', 150000, 1),
(5, 'Xbox Controller', 'Gaming', 1200000, 0);


-- Thêm dữ liệu mẫu vào bảng Orders
INSERT INTO ngay_2.Orders (order_id, user_id, order_date, status) VALUES
(1001, 1, '2023-02-01', 'completed'),
(1002, 2, '2023-02-10', 'cancelled'),
(1003, 3, '2023-02-12', 'completed'),
(1004, 4, '2023-02-15', 'completed'),
(1005, 1, '2023-03-01', 'pending');


-- Thêm dữ liệu mẫu vào bảng OrderItems
INSERT INTO ngay_2.OrderItems (order_id, product_id, quantity) VALUES
(1001, 1, 1),
(1001, 3, 3),
(1003, 2, 1),
(1003, 4, 2),
(1004, 3, 5),
(1005, 2, 1);



--1. Phân tích doanh thu: Tính tổng doanh thu từ các đơn hàng completed, nhóm theo danh mục sản phẩm.
SELECT 
    p.category AS category,
    SUM(oi.quantity * p.price) AS total_revenue
FROM ngay_2.Orders o
JOIN ngay_2.OrderItems oi ON o.order_id = oi.order_id
JOIN ngay_2.Products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category;

-- 2. Người dùng giới thiệu: Tạo danh sách các người dùng kèm theo tên người giới thiệu (dùng self join).
SELECT 
    u.user_id, 
    u.full_name, 
    u.city, 
    u.created_at, 
    r.full_name AS referrer_name
FROM ngay_2.Users u
LEFT JOIN ngay_2.Users r ON u.referrer_id = r.user_id;

-- 3. Sản phẩm không còn bán: Tìm các sản phẩm đã từng được đặt mua nhưng hiện tại không còn active.
SELECT DISTINCT p.product_id, p.product_name
FROM ngay_2.Products p
JOIN ngay_2.OrderItems oi ON p.product_id = oi.product_id
WHERE p.is_active = 0;

-- 4. Người dùng "chưa hoạt động": Tìm các người dùng chưa từng đặt bất kỳ đơn hàng nào.
SELECT u.user_id, u.full_name
FROM ngay_2.Users u
LEFT JOIN ngay_2.Orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;

-- 5. Đơn hàng đầu tiên của từng người dùng: Với mỗi user, tìm order_id tương ứng với đơn hàng đầu tiên của họ.
SELECT o.user_id, o.order_id, o.order_date
FROM ngay_2.Orders o
INNER JOIN (
    SELECT user_id, MIN(order_date) AS first_order_date
    FROM ngay_2.Orders
    GROUP BY user_id
) t ON o.user_id = t.user_id AND o.order_date = t.first_order_date;

-- 6. Tổng chi tiêu của mỗi người dùng: Viết truy vấn lấy tổng tiền mà từng người dùng đã chi tiêu (chỉ tính đơn hàng completed).
SELECT u.user_id, u.full_name, COALESCE(SUM(oi.quantity * p.price), 0) AS total_spent
FROM ngay_2.Users u
LEFT JOIN ngay_2.Orders o ON u.user_id = o.user_id AND o.status = 'completed'
LEFT JOIN ngay_2.OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN ngay_2.Products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.full_name;

-- 7. Lọc người dùng tiêu nhiều: Từ kết quả trên, chỉ lấy các user có tổng chi tiêu > 25 triệu.
SELECT user_id, full_name, total_spent
FROM (
    SELECT u.user_id, u.full_name, COALESCE(SUM(oi.quantity * p.price), 0) AS total_spent
    FROM ngay_2.Users u
    LEFT JOIN ngay_2.Orders o ON u.user_id = o.user_id AND o.status = 'completed'
    LEFT JOIN ngay_2.OrderItems oi ON o.order_id = oi.order_id
    LEFT JOIN ngay_2.Products p ON oi.product_id = p.product_id
    GROUP BY u.user_id, u.full_name
) t
WHERE total_spent > 25000000;

-- 8. So sánh các thành phố: Tính tổng số đơn hàng và tổng doanh thu của từng thành phố.
SELECT u.city, COUNT(DISTINCT o.order_id) AS total_orders, COALESCE(SUM(oi.quantity * p.price), 0) AS total_revenue
FROM ngay_2.Users u
LEFT JOIN ngay_2.Orders o ON u.user_id = o.user_id AND o.status = 'completed'
LEFT JOIN ngay_2.OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN ngay_2.Products p ON oi.product_id = p.product_id
GROUP BY u.city;

-- 9. Người dùng có ít nhất 2 đơn hàng completed: Truy xuất danh sách người dùng thỏa điều kiện.
SELECT u.user_id, u.full_name, COUNT(o.order_id) AS completed_orders
FROM ngay_2.Users u
JOIN ngay_2.Orders o ON u.user_id = o.user_id AND o.status = 'completed'
GROUP BY u.user_id, u.full_name
HAVING COUNT(o.order_id) >= 2;

-- 10. Tìm đơn hàng có sản phẩm thuộc nhiều hơn 1 danh mục
SELECT oi.order_id
FROM ngay_2.OrderItems oi
JOIN ngay_2.Products p ON oi.product_id = p.product_id
GROUP BY oi.order_id
HAVING COUNT(DISTINCT p.category) > 1;

-- 11. Kết hợp danh sách: Dùng UNION để kết hợp 2 danh sách:
-- A: người dùng đã từng đặt hàng
-- B: người dùng được người khác giới thiệu
-- (loại trùng lặp, lấy user_id, full_name, nguồn đến: "placed_order" hoặc "referred")
SELECT DISTINCT u.user_id, u.full_name, 'placed_order' AS source
FROM ngay_2.Users u
JOIN ngay_2.Orders o ON u.user_id = o.user_id
UNION
SELECT DISTINCT u.user_id, u.full_name, 'referred' AS source
FROM ngay_2.Users u
WHERE u.referrer_id IS NOT NULL;