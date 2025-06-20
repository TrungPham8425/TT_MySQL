-- # 1. EXISTS
-- Dùng để kiểm tra sự tồn tại của bán ghi trong một truy vấn con
-- VD: Kiểm tra khách hàng có đơn hàng
-- SELECT name
-- FROM Customers c
-- WHERE EXISTS (
--   SELECT 1
--   FROM Orders o
--   WHERE o.customer_id = c.customer_id
-- );

-- # 2. ANY, ALL
-- * ANY:
-- Dùng so sánh với ít nhất một giá trọ trong tập con
-- VD: Lấy sản phẩm có giá lớn hơn bất kỳ của sản phẩm trong mục Book
-- SELECT *
-- FROM Products
-- WHERE price > ANY (
--   SELECT price
--   FROM Products
--   WHERE category = 'Book'
-- );

-- * ALL:
-- Dùng so sánh với tất cả giá trị trong tập con
-- VD: 
-- SELECT *
-- FROM Products
-- WHERE price > ALL (
--   SELECT price
--   FROM Products
--   WHERE category = 'Book'
-- );

-- # 3. INSERT SELECT
-- Dùng để chèn dữ liệu từ một truy vấn vào bảng khác
-- VD: 
-- INSERT INTO ArchivedOrders (order_id, customer_id, order_date)
-- SELECT order_id, customer_id, order_date
-- FROM Orders
-- WHERE order_date < '2023-01-01';

-- # 4. CASE
-- Dùng để tạo điều kiện rẽ nhánh trong truy vấn
-- VD:
-- SELECT name,
--        CASE
--          WHEN gender = 'M' THEN 'Male'
--          WHEN gender = 'F' THEN 'Female'
--          ELSE 'Other'
--        END AS gender_text
-- FROM Users;

-- 5. Null Functions
-- * IS NULL / IS NOT NULL:
-- Dùng để kiểm tra một giá trị có phải là NULL không
-- VD: 
-- SELECT * FROM users WHERE email IS NULL;
-- SELECT * FROM users WHERE phone_number IS NOT NULL;

-- * IFNULL(expr1, expr2)
-- Trả về expr2 nếu expr1 là null, ngược lại chả về expr1
-- VD: 
-- SELECT name, IFNULL(email, 'Chưa có email') AS email FROM users;

-- * COALESCE(expr1, expr2, ..., exprN)
-- Trả về giá trị Null đầu tiên trong danh sách
-- VD:
-- SELECT name, COALESCE(email, phone, 'Không có liên hệ') AS contact FROM users;

-- * NULLIF(expr1, expr2)
-- Trả về NULL nếu 2 điều kiện bằng nhau, ngược lại trả về điều kiện 1 
-- VD:
-- SELECT NULLIF(score, 0) FROM results;

-- * ISNULL(expr)
-- Trả về 1 nếu điều kiện NULL nếu NOT NULL trả về 0
-- VD:
-- SELECT ISNULL(phone_number) AS is_null FROM users;

-- # 6. Comments
-- Comments trong SQL có 2 dạng comment
-- Đây là cách 1
/*Đây là cách 2*/

-- # 7. Operators
-- Có 6 loại toán tử trong SQL
-- * Số học (+, -, *, /, %)
-- * So sánh (=, <>, !=, <, >, >=, <=)
-- * Logic (AND, OR, NOT)
-- * NULL (IS NULL, IS NOT NULL)
-- * Tập hợp (IN, NOT IN, EXISTS, ANY, ALL)