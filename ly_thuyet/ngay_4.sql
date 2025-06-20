-- # 1. Creata DB
-- Dùng để tạo database 
-- VD: CREATE DATABASE ShopDB;

-- # 2. DROP DB
-- Dùng để xóa database
-- VD: DROP DATABASE ShopDB;

-- # 3.  Create Table
-- Tạo bảng trong SQL sử dụng câu lệnh CREATE TABLE();
-- VD: 
-- CREATE TABLE Customers (
--   customer_id INT PRIMARY KEY AUTO_INCREMENT,
--   name VARCHAR(100) NOT NULL,
--   email VARCHAR(100) UNIQUE,
--   age INT CHECK (age >= 18),
--   created_at DATE DEFAULT CURRENT_DATE
-- );

-- # 4. Drop Table
-- Dể xóa bảng xử dụng câu lệnh: DROP TABLE ten_bang;
-- VD: DROP TABLE Customers;

-- # 5. ALTER TABLE 
-- Dùng để thay đổi các cột trong bảng sau một cột nào đó
-- VD: xóa cột
-- ALTER TABLE Customers DROP COLUMN phone;

-- # 6. CONSTRAINTS
-- Là các ràng buộc dữ liệu áp dụng lên cột trong bảng để đảm bảo tính toàn vẹn dữ liệu.

-- NOT NULL    -> Cột không được chứa giá trị NULL
-- UNIQUE      -> Các giá trị trong cột là duy nhất
-- PRIMARY KEY -> Khóa chính, đồng thời là NOT NULL và UNIQUE
-- FOREIGN KEY -> Khóa ngoại, tham chiếu tới bảng khác
-- CHECK       -> Ràng buộc điều kiện logic (VD: CHECK (age >= 18))
-- DEFAULT     -> Giá trị mặc định nếu không nhập vào

-- VD: 
-- CREATE TABLE Orders (
--     order_id INT PRIMARY KEY AUTO_INCREMENT,
--     customer_id INT,
--     total DECIMAL(10, 2) CHECK (total > 0),
--     order_date DATE DEFAULT CURRENT_DATE,
--     FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
-- );


