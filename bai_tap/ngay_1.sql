-- Xóa database nếu tồn tại (để có thể chạy lại script nhiều lần)
DROP DATABASE IF EXISTS ngay_1;

-- Tạo database mới
CREATE DATABASE ngay_1;
USE ngay_1;
SHOW TABLES;

-- Tạo bảng Customers
CREATE TABLE ngay_1.Customers(
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    city VARCHAR(255),
    email VARCHAR(100) 
);

-- Tạo bảng Orders
CREATE TABLE ngay_1.Orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES ngay_1.Customers(customer_id)
);

-- Tạo bảng Products
CREATE TABLE ngay_1.Products(
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2)
);

-- Chèn dữ liệu vào bảng Customers
INSERT INTO ngay_1.Customers (customer_id, name, city, email) VALUES
(1, 'Nguyen An', 'Hanoi', 'an.nguyen@email.com'),
(2, 'Tran Binh', 'Ho Chi Minh', NULL),
(3, 'Le Cuong', 'Da Nang', 'cuong.le@email.com'),
(4, 'Hoang Duong', 'Hanoi', 'duong.hoang@email.com');

-- Chèn dữ liệu vào bảng Orders
INSERT INTO ngay_1.Orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2023-01-15', 500000),
(102, 3, '2023-02-10', 800000),
(103, 2, '2023-03-05', 300000),
(104, 1, '2023-04-01', 450000);

-- Chèn dữ liệu vào bảng Products
INSERT INTO ngay_1.Products (product_id, name, price) VALUES
(1, 'Laptop Dell', 15000000),
(2, 'Mouse Logitech', 300000),
(3, 'Keyboard Razer', 1200000),
(4, 'Laptop HP', 14000000);

-- 1. Lấy danh sách khách hàng đến từ Hà Nội
SELECT * FROM ngay_1.Customers WHERE city='Hanoi';

-- 2. Tìm những đơn hàng có giá trị trên 400.000 đồng và được đặt sau ngày 31/01/2023.
SELECT * FROM ngay_1.Orders WHERE total_amount>400000 AND order_date >'2023/01/31';

-- 3. Lọc ra các khách hàng chưa có địa chỉ email
SELECT * FROM ngay_1.Customers WHERE email IS NULL;

-- 4. Xem toàn bộ đơn hàng, sắp xếp theo tổng tiền từ cao xuống thấp.
SELECT * FROM ngay_1.Orders ORDER BY total_amount DESC;

-- 5. Thêm khách hàng mới
INSERT INTO ngay_1.Customers (customer_id, name, city, email) VALUES (5, 'Pham Thanh', 'Can Tho', NULL);
-- Hiển thị lại bảng sau khi thêm mới
SELECT * FROM ngay_1.Customers;

-- 6. Cập nhật địa chỉ email của khách hàng có mã là 2 thành "binh.tran@email.com".
UPDATE ngay_1.Customers SET email = "binh.tran@email.com" WHERE customer_id = 2;
-- Hiển thị lại bảng sau khi cập nhật
SELECT * FROM ngay_1.Customers;

-- 7. Xóa đơn hàng có mã là 103 vì bị nhập nhầm.
DELETE FROM ngay_1.Orders WHERE order_id = 103;
SELECT * FROM ngay_1.Orders;

-- 8. Lấy danh sách 2 khách hàng đầu tiên trong bảng.
SELECT * FROM ngay_1.Customers LIMIT 2;

-- 9. Quản lý muốn biết đơn hàng có giá trị lớn nhất và nhỏ nhất hiện tại là bao nhiêu.
SELECT 
    MAX(total_amount) as 'Giá trị đơn hàng lớn nhất',
    MIN(total_amount) as 'Giá trị đơn hàng nhỏ nhất'
FROM ngay_1.Orders;

-- 10. Tính tổng số lượng đơn hàng, tổng số tiền đã bán ra và trung bình giá trị một đơn hàng.
SELECT 
    COUNT(order_id) as 'Tổng số lượng đơn hàng',
    SUM(total_amount) as 'Tổng số tiền đã bán',
    AVG(total_amount) as 'Giá trị trung bình đơn hàng'
FROM ngay_1.Orders; 

-- 11. Tìm những sản phẩm có tên bắt đầu bằng chữ "Laptop".
SELECT * FROM ngay_1.Products WHERE name LIKE 'Laptop%';

/*
12. Mô tả ngắn gọn RDBMS là gì và vai trò của các mối quan hệ giữa các bảng trong hệ thống này

1. RDBMS (Relational Database Management System):
- Hệ thống quản lý cơ sở dữ liệu quan hệ
- Lưu trữ dữ liệu dưới dạng các bảng có mối quan hệ với nhau

2. Các bảng trong hệ thống:
- Customers: Lưu thông tin khách hàng (customer_id là khóa chính)
- Orders: Lưu thông tin đơn hàng (order_id là khóa chính, customer_id là khóa ngoại)
- Products: Lưu thông tin sản phẩm (product_id là khóa chính)

3. Vai trò của mối quan hệ:
- Đảm bảo tính toàn vẹn dữ liệu
- Tránh dữ liệu trùng lặp
- Dễ dàng truy vấn và phân tích dữ liệu
*/ 