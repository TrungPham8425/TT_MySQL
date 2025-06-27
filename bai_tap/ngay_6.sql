CREATE DATABASE ngay_6;
USE ngay_6;

-- 1. STORAGE ENGINE


-- Bảng Accounts dùng InnoDB
CREATE TABLE ngay_6.Accounts (
    account_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    balance DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Active', 'Frozen', 'Closed'))
) ENGINE=InnoDB;

-- Bảng Transactions dùng InnoDB
CREATE TABLE ngay_6.Transactions (
    txn_id INT PRIMARY KEY,
    from_account INT,
    to_account INT,
    amount DECIMAL(18,2) NOT NULL,
    txn_date TIMESTAMP NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Success', 'Failed', 'Pending')),
    FOREIGN KEY (from_account) REFERENCES Accounts(account_id),
    FOREIGN KEY (to_account) REFERENCES Accounts(account_id)
) ENGINE=InnoDB;

-- Bảng Users (quản lý thông tin đăng nhập) dùng InnoDB
CREATE TABLE ngay_6.Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
) ENGINE=InnoDB;

-- Bảng Branches (chi nhánh ngân hàng) dùng InnoDB
CREATE TABLE ngay_6.Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(200)
) ENGINE=InnoDB;

-- Bảng Account_Branch (liên kết tài khoản với chi nhánh) dùng InnoDB
CREATE TABLE ngay_6.Account_Branch (
    account_id INT,
    branch_id INT,
    PRIMARY KEY (account_id, branch_id),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
) ENGINE=InnoDB;

-- Bảng TxnAuditLogs dùng MyISAM
CREATE TABLE ngay_6.TxnAuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    txn_id INT,
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    note VARCHAR(255)
) ENGINE=MyISAM;

-- Chèn dữ liệu mẫu cho các bảng
INSERT INTO ngay_6.Accounts VALUES
(1, 'Nguyen Van A', 10000000, 'Active'),
(2, 'Tran Thi B', 5000000, 'Frozen'),
(3, 'Le Van C', 2000000, 'Active'),
(4, 'Pham Thi D', 0, 'Closed');

INSERT INTO ngay_6.Users VALUES
(1, 'nguyenvana', 'passA', 1),
(2, 'tranthib', 'passB', 2),
(3, 'levanc', 'passC', 3),
(4, 'phamthid', 'passD', 4);

INSERT INTO ngay_6.Branches VALUES
(1, 'Chi nhánh Hà Nội', '123 Đường A, Hà Nội'),
(2, 'Chi nhánh TP.HCM', '456 Đường B, TP.HCM');

INSERT INTO ngay_6.Account_Branch VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2);

INSERT INTO ngay_6.Transactions VALUES
(1, 1, 2, 1000000, '2024-06-01 09:00:00', 'Success'),
(2, 2, 3, 500000, '2024-06-02 10:30:00', 'Pending'),
(3, 3, 1, 200000, '2024-06-03 14:15:00', 'Failed'),
(4, 1, 4, 300000, '2024-06-04 16:45:00', 'Success');

INSERT INTO ngay_6.TxnAuditLogs (txn_id, action, note) VALUES
(1, 'CREATE', 'Tạo giao dịch chuyển tiền'),
(2, 'UPDATE', 'Cập nhật trạng thái giao dịch'),
(3, 'FAILED', 'Giao dịch thất bại'),
(4, 'CREATE', 'Tạo giao dịch mới');

-- Giải thích Storage Engine
-- InnoDB:
-- Hỗ trợ transaction (ACID), khóa ngoại, row-level locking (khóa dòng).
-- Phục hồi tốt khi bị crash, phù hợp cho hệ thống cần an toàn dữ liệu, nhiều thao tác ghi/lấy đồng thời.
-- MyISAM:
-- Không hỗ trợ transaction, không có khóa ngoại, chỉ có table-level locking (khóa bảng).
-- Tốc độ đọc rất nhanh, phù hợp cho hệ thống chủ yếu đọc, không cần tính toàn vẹn dữ liệu cao.
-- MEMORY:
-- Dữ liệu lưu trên RAM, cực nhanh nhưng mất hết khi restart MySQL.
-- Không hỗ trợ transaction, không có khóa ngoại, chỉ dùng cho dữ liệu tạm/thao tác nhanh.


-- 2. TRANSACTIONS & CHỐNG DEADLOCK


-- Stored Procedure chuyển tiền giữa hai tài khoản, chống deadlock
CREATE PROCEDURE ngay_6.TransferMoney(
    IN p_from_account INT,
    IN p_to_account INT,
    IN p_amount DECIMAL(18,2)
)
BEGIN
    DECLARE v_from_balance DECIMAL(18,2);
    DECLARE v_from_status VARCHAR(20);
    DECLARE v_to_status VARCHAR(20);
    DECLARE v_error INT DEFAULT 0;
    DECLARE v_message VARCHAR(255);

    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Khóa hai tài khoản theo thứ tự tăng dần để chống deadlock
    IF p_from_account < p_to_account THEN
        SELECT balance, status INTO v_from_balance, v_from_status FROM Accounts WHERE account_id = p_from_account FOR UPDATE;
        SELECT status INTO v_to_status FROM Accounts WHERE account_id = p_to_account FOR UPDATE;
    ELSE
        SELECT status INTO v_to_status FROM Accounts WHERE account_id = p_to_account FOR UPDATE;
        SELECT balance, status INTO v_from_balance, v_from_status FROM Accounts WHERE account_id = p_from_account FOR UPDATE;
    END IF;

    -- Kiểm tra trạng thái
    IF v_from_status <> 'Active' OR v_to_status <> 'Active' THEN
        SET v_error = 1;
        SET v_message = 'Một trong hai tài khoản không ở trạng thái Active';
    END IF;

    -- Kiểm tra số dư
    IF v_error = 0 AND v_from_balance < p_amount THEN
        SET v_error = 1;
        SET v_message = 'Tài khoản nguồn không đủ tiền';
    END IF;

    -- Thực hiện chuyển tiền nếu không có lỗi
    IF v_error = 0 THEN
        UPDATE Accounts SET balance = balance - p_amount WHERE account_id = p_from_account;
        UPDATE Accounts SET balance = balance + p_amount WHERE account_id = p_to_account;
        
        INSERT INTO Transactions (txn_id, from_account, to_account, amount, txn_date, status)
        VALUES (NULL, p_from_account, p_to_account, p_amount, NOW(), 'Success');
        
        INSERT INTO TxnAuditLogs (txn_id, action, note)
        VALUES (LAST_INSERT_ID(), 'TRANSFER', CONCAT('Chuyển ', p_amount, ' từ ', p_from_account, ' sang ', p_to_account));
        
        COMMIT;
    ELSE
        -- Ghi log thất bại
        INSERT INTO TxnAuditLogs (txn_id, action, note)
        VALUES (NULL, 'FAILED', v_message);
        ROLLBACK;
    END IF;
END;

-- 3. MVCC – Multi-Version Concurrency Control
-- Ví dụ: Hiển thị số dư tài khoản trong khi session khác thực hiện chuyển tiền
-- Session 1:
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT balance FROM Accounts WHERE account_id = 1;
-- (Giữ nguyên transaction, KHÔNG COMMIT)
--
-- Session 2 (ở một cửa sổ khác):
-- START TRANSACTION;
-- UPDATE Accounts SET balance = balance - 100000 WHERE account_id = 1;
-- COMMIT;
--
-- Quay lại Session 1:
-- SELECT balance FROM Accounts WHERE account_id = 1;
-- (Kết quả vẫn là số dư ban đầu do hiệu ứng snapshot của MVCC)
-- COMMIT;

-- 4. COMMON TABLE EXPRESSION (CTE)

-- a. CTE Đệ Quy: Liệt kê tất cả cấp dưới nhiều tầng của một khách hàng
CREATE TABLE Referrals (
    referrer_id INT,
    referee_id INT
);

INSERT INTO Referrals VALUES
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 6),
(6, 7);

-- CTE đệ quy liệt kê tất cả cấp dưới của referrer_id = 1
WITH RECURSIVE AllReferees AS (
    SELECT referrer_id, referee_id, 1 AS level
    FROM Referrals
    WHERE referrer_id = 1
    UNION ALL
    SELECT r.referrer_id, r.referee_id, ar.level + 1
    FROM Referrals r
    INNER JOIN AllReferees ar ON r.referrer_id = ar.referee_id
)
SELECT * FROM AllReferees;

-- b. CTE Truy vấn phức tạp: Giao dịch lớn hơn trung bình, gắn nhãn
WITH AvgAmount AS (
    SELECT AVG(amount) AS avg_amt FROM Transactions
),
LabeledTxns AS (
    SELECT t.*, 
        CASE 
            WHEN t.amount > (SELECT avg_amt FROM AvgAmount) * 1.5 THEN 'High'
            WHEN t.amount < (SELECT avg_amt FROM AvgAmount) * 0.5 THEN 'Low'
            ELSE 'Normal'
        END AS label
    FROM Transactions t
)
SELECT * FROM LabeledTxns WHERE amount > (SELECT avg_amt FROM AvgAmount);