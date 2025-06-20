-- # 1. VIEW
-- View là một bảng ảo, được tạo từ câu truy vấn SELECT.
-- View không lưu dữ liệu, chỉ lưu truy vấn.
-- Dùng để đơn giản hóa truy vấn phức tạp hoặc bảo mật dữ liệu.

-- Tạo VIEW hiển thị khách hàng từ Hà Nội
/*
CREATE VIEW HanoiCustomers AS
SELECT customer_id, name, email
FROM Customers
WHERE city = 'Hanoi';
*/

-- Sử dụng VIEW
-- SELECT * FROM HanoiCustomers;

-- Xóa VIEW
-- DROP VIEW HanoiCustomers;

-- # 2. STORED PROCEDURE (Thủ tục lưu trữ)
-- Là tập hợp các câu lệnh SQL được lưu trong CSDL và có thể gọi lại để thực thi.
-- Giúp tái sử dụng logic, tăng hiệu năng.

-- Tạo Stored Procedure thêm khách hàng mới
-- DELIMITER $$  -- Cú pháp đổi dấu kết thúc để định nghĩa Procedure

/* 
CREATE PROCEDURE AddCustomer(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_city VARCHAR(50)
)
BEGIN
    INSERT INTO Customers(name, email, city)
    VALUES(p_name, p_email, p_city);
END$$
*/

-- DELIMITER ;  -- Đặt lại dấu kết thúc là dấu ;

-- Gọi procedure:
-- CALL AddCustomer('Nguyen Van A', 'vana@email.com', 'Hanoi');

-- Xóa procedure:
-- DROP PROCEDURE AddCustomer;


-- # 3. TRIGGER
-- Trigger là thủ tục tự động được thực thi khi có hành động INSERT, UPDATE, DELETE trên bảng.
-- Dùng để kiểm tra, tự động ghi log, cập nhật dữ liệu phụ...

-- Ví dụ: Trigger tự động ghi log mỗi khi có khách hàng mới được thêm

-- Tạo bảng log
/*
CREATE TABLE CustomerLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

-- Tạo Trigger
/*
DELIMITER $$

CREATE TRIGGER trg_after_insert_customer
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLogs(customer_id, action)
    VALUES(NEW.customer_id, 'INSERT');
END$$

DELIMITER ;
*/

-- Xóa trigger
-- DROP TRIGGER trg_after_insert_customer;