-- # 1. RDBMS --
-- - RDBMS hay còn gọi là Relational Database Management System
-- - Là hệ quản trị cơ sở dữ liệu quan hệ - lưu trư dữ liệu dưới dạng bảng gồm các hàng và cột
-- - Đặc điểm chính:
-- + Sử dụng SQL để truy vấn 
-- + Các bảng có thể liên kết với nhai thông qua khóa ngoại(foregin key) 
-- + Hỗ trợ ràng buộc dữ liệu, chỉ mục, transaction, ...

-- # 2. SELECT
-- - VD: SELECT * FORM tablde
-- - Dùng để lấy dữ liệu từ bảng có thể lấy tất cả dữ liệu từ bảng đó hoặc chỉ lấy dữ liệu cần tìm


-- # 3. WHERE
-- - Dùng để lọc dữ liệu theo điều kiện
-- VD: SELECT * FROM products WHERE price > 100;
-- (Lấy tất cả dữ liệu ở bảng sản phẩm có giá lớn hơn 100)

-- # 4. AND, OR, NOT
-- - AND: dùng để lấy tất cả điều kiện đúng
-- - OR: lấy một diều kiện dúng duy nhất
-- - NOT: phủ định diều kiện
-- VD: 
-- AND: lấy người dùng ở bảng users lớn hơn 18 tuổi và có giới tính là male 
-- SELECT * FROM users WHERE age > 18 AND gender = 'male';
-- OR: Lấy người dùng có địa chỉ ở Huế hoặc Hà Nội
-- SELECT * FROM users WHERE city = 'Hanoi' OR city = 'Hue';
-- NOT: 
-- SELECT * FROM users WHERE NOT country = 'Vietnam';

-- # 5. ORDER BY
-- - Dùng để sắp xếp dữ liệu lấy ra theo thứ tự 
-- VD: sắp xếp kết quả theo một hoặc nhiều cột
-- SELECT * FROM table_name ORDER BY column1 [ASC|DESC];

-- # 6. INSERT INTO 
-- - Dùng để thêm dữ liệu vào bảng 
-- VD: thêm tên và email vào bảng người dùng
-- INSERT INTO users (name, email) VALUES ('Trung', 'trung@email.com');

-- # 7. NULL Value
-- - NULL là giá trị rỗng nó không phải là giá trị 0 hay chuỗi rỗng
-- - So sánh dùng IS NULL hoặc IS NOT NULL
-- VD: SELECT * FROM users WHERE phone IS NULL;

-- # 8. UPDATE
-- - Sử dụng để sửa dữ liệu của bản ghi trong bảng
-- VD: UPDATE users SET name = 'Trung Pham' WHERE id = 1;

-- # 9. DELETE 
-- Dùng để xóa bản ghi bất kỳ theo điều kiện trong bảng
-- VD: DELETE FROM users WHERE id = 1;

-- # 10. LIMIT
-- - Dùng để giới hạn số lượng bảng ghi trả về từ bảng 
-- VD: Lấy tối đa 5 bài viết từ bảng bài viết
-- SELECT * FROM posts LIMIT 5;

-- # 11. MIN anh MAX 
-- - Dùng để lấy giá trị lớn nhất hoặc bé nhất trong bảng
-- VD:
-- SELECT MIN(price) FROM products;(Lấy giá nhỏ nhất trong bảng sản phẩm)
-- SELECT MAX(age) FROM users;(Lấy tuổi lớn nhất trong bảng người dùng)

-- # 12. COUNT, AVG, SUM
-- Dùng để thực hiện tính tổng, tính trung bình và đếm số dòng
-- + COUNT dùng để để số dòng, số ký tự
-- + AVG dùng để tính trung bình
-- + SUM dùng để tính tổng

-- # 13. LIKE
-- Dùng để tìm chuỗi ký tự gần đúng thường dùng để xây dựng chức năng tìm kiếm trong dự án
-- VD: SELECT * FROM table_name WHERE column LIKE 'pattern';

-- # 14. Wildcards
-- Dùng với LIKE để đại diện cho ký tự
-- %: bất kỳ số ký tự nào
-- _: Một ký tự duy nhất
-- VD: SELECT * FROM users WHERE name LIKE '_ung'; -- có 4 chữ, kết thúc bằng "ung"
