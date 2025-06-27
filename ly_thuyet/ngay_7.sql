-- Tối ưu truy vấn CSDL – Phần 1

# 1. Sử dụng EXPLAIN để phân tích kế hoạch thực thi
EPLANT dùng để hiểu CSDL sẽ chạy truy vấn như thế nào bao gồm
+ Có sử dụng index không
+ Kiểu join nào được dùng
+ Truy vấn quét bao nhiêu dòng dữ liệu
+ Thứ tự được xử lý thê nào

VD:
EXPLAIN SELECT * FROM users WHERE email = 'abc@example.com';

# 2. Tạo chỉ mục (Index) phù hợp
Việc tạo index phù hợp giúp tăng tốc độ truy vấn, đặc biệt là các cột trong WHERE, JOIN, ORDER BY, GROUP BY

# 3. Sử dụng Composite Index khi truy vấn nhiều cột
Tạo chỉ mục bao gồm nhiều cột theo đúng thứ tự truy vấn.
Composite index chỉ hoạt động hiệu quả nếu bạn truy vấn theo thứ tự từ trái sang phải của index.

VD:
CREATE INDEX idx_user_status_created ON users(status, created_at);

4. Tránh dùng SELECT *
Chỉ nên lấy câc cột cần thiết để giảm tải xử lý và truyền dữ liệu

# 5. Sử dụng JOIN và Subquery phù hợp
+ JOIN: Dùng khi càn liên kết dữ liệu từ nhiều bảng
+ Subquery: dùng khi cần truy vấn phụ thuộc nhánh chính
* Không nên join quá nhiều bảng hoặc subquery lồng nhiều cấp.

# 6. Thêm điều kiện WHERE để lọc dữ liệu sớm
Việc thêm điều kiện giúp cho CSDL chỉ duyệt dữ liệu liên quan và giúp tiết kiệm bộ nhớ hơn
VD: SELECT * FROM orders WHERE status = 'completed';

# 7. Tránh dùng hàm trong WHERE hoặc JOIN
Việc tránh dùng hàm trong WHERE hoặc JOIN là một nguyên tắc quan trọng trong tối ưu hóa truy vấn SQL, vì nó ảnh hưởng trực tiếp đến khả năng sử dụng chỉ mục (index).
Khi dùng hàm trên cột trong WHERE hoặc JOIN, CSDL không thể sử dụng chỉ mục vì:
+ Chỉ mục hoạt động trên giá trị gốc của cột.
+ Hàm làm thay đổi cột đó → CSDL phải duyệt toàn bộ bảng.

# 8. Sử dụng Covering Index
Covering Index chứa đủ các  cột được truy vấn giúp không cần truy cập vào bảng chính mà vẫn lấy được bản ghi

# 9. Tối ưu ORDER BY và GROUP BY bằng index
Việc tối ưu ORDER BY và GROUP BY bằng chỉ mục (index) giúp tăng hiệu suất truy vấn đáng kể, tránh việc CSDL phải sắp xếp (sort) hay dùng bộ nhớ tạm (temporary table).
+ ORDER BY và GROUP BY thường là nguyên nhân gây chậm truy vấn, đặc biệt khi kết hợp với JOIN, LIMIT, hoặc dữ liệu lớn.
+ Khi có index phù hợp, CSDL có thể trả về dữ liệu đã được sắp xếp sẵn, không cần xử lý thêm.

# 10. Chia nhỏ truy vấn phức tạp
- Việc chia nhỏ truy vấn phức tạp là một chiến lược tối ưu quan trọng giúp:
+ Dễ hiểu hơn
+ Tăng hiệu suất
+ Dễ dàng trong việc tái sử dụng truy vấn phụ
+ Giảm lỗi logic hoặc lỗi bộ nhớ tạm

- Khi truy vấn có nhiều bảng JOIN, GROUP BY, HAVING, ORDER BY kết hợp hoặc Subquery lồng nhau, CASE phức tạp ta cần chia nhỏ vì:
+ CSDL có thể tạo bảng tạm (temporary), tốn RAM/CPU hoặc không dùng được index.
+ Chia nhỏ truy vấn giúp dễ quản lý, chạy nhanh hơn, đặc biệt với dữ liệu lớn.

# 11. Dùng LIMIT khi chỉ cần một phần dữ liệu
Việc dùng LIMIT giúp giảm chi phí truy vấn khi chỉ cần lấy một phần kết quả.