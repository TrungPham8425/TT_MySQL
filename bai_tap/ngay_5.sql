-- Xóa database nếu đã tồn tại để tránh lỗi khi chạy lại
DROP DATABASE IF EXISTS ngay_5;
CREATE DATABASE ngay_5;
USE ngay_5;

-- Tạo bảng Rooms
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE,
    type VARCHAR(20),
    status VARCHAR(20),
    price INT CHECK (price >= 0)
);

-- Tạo bảng Guests
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Tạo bảng Bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    status VARCHAR(20),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Tạo bảng Invoices (cho phần bonus)
CREATE TABLE Invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    total_amount INT,
    generated_date DATE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- 1. STORED PROCEDURE: MakeBooking
-- Thủ tục đặt phòng với kiểm tra phòng và trùng lịch
DELIMITER $$
CREATE PROCEDURE MakeBooking(
    IN p_guest_id INT,
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    -- Bước 1: Kiểm tra phòng có status = 'Available'
    IF (SELECT status FROM Rooms WHERE room_id = p_room_id) != 'Available' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is not available!';
    END IF;

    -- Bước 2: Kiểm tra không có đặt phòng nào khác trùng thời gian
    IF EXISTS (
        SELECT 1 FROM Bookings
        WHERE room_id = p_room_id
          AND status = 'Confirmed'
          AND (
                (p_check_in < check_out AND p_check_out > check_in)
              )
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is already booked for the selected dates!';
    END IF;

    -- Bước 3: Nếu hợp lệ, tạo bản ghi mới và cập nhật trạng thái phòng
    INSERT INTO Bookings (guest_id, room_id, check_in, check_out, status)
    VALUES (p_guest_id, p_room_id, p_check_in, p_check_out, 'Confirmed');

    UPDATE Rooms SET status = 'Occupied' WHERE room_id = p_room_id;
END $$
DELIMITER ;

-- 2. TRIGGER: after_booking_cancel
-- Tự động cập nhật trạng thái phòng khi đặt phòng bị hủy
DELIMITER $$
CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    -- Nếu trạng thái chuyển thành Cancelled
    IF NEW.status = 'Cancelled' THEN
        -- Kiểm tra không còn booking nào khác cho phòng này trong tương lai với trạng thái Confirmed
        IF NOT EXISTS (
            SELECT 1 FROM Bookings
            WHERE room_id = NEW.room_id
              AND status = 'Confirmed'
              AND check_in > CURDATE()
        ) THEN
            -- Nếu không còn booking nào khác, cập nhật phòng thành Available
            UPDATE Rooms SET status = 'Available' WHERE room_id = NEW.room_id;
        END IF;
    END IF;
END $$
DELIMITER ;

-- 3. BONUS: STORED PROCEDURE GenerateInvoice
-- Tạo hóa đơn cho booking, tính số đêm và tổng tiền
DELIMITER $$
CREATE PROCEDURE GenerateInvoice(IN p_booking_id INT)
BEGIN
    DECLARE v_nights INT;
    DECLARE v_price INT;
    DECLARE v_total INT;

    -- Bước 1: Lấy số đêm và giá phòng
    SELECT DATEDIFF(check_out, check_in), r.price
    INTO v_nights, v_price
    FROM Bookings b
    JOIN Rooms r ON b.room_id = r.room_id
    WHERE b.booking_id = p_booking_id;

    -- Bước 2: Tính tổng tiền
    SET v_total = v_nights * v_price;

    -- Bước 3: Tạo hóa đơn
    INSERT INTO Invoices (booking_id, total_amount, generated_date)
    VALUES (p_booking_id, v_total, CURDATE());
END $$
DELIMITER ;
