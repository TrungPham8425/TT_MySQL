# 1.  1. Cost Model
- Cost Model là mô hình tính toán chi phí mà MySQL sử dụng để quyết định chọn kế hoạch truy vấn nào là tối ưu nhất.
- MySQL sử dụng chi phí I/O và CPU để ước lượng chi phí thực thi cho từng kế hoạch truy vấn.
+ Nó ưu tiên kế hoạch có chi phí thấp nhất.
+ Chi phí này được tính dựa trên:
+ Số dòng dữ liệu cần đọc.
+ Có sử dụng index hay không.
+ Kiểu Join nào (Nested Loop, Hash Join…).
+ Dự đoán lượng tài nguyên sử dụng.

#  2. Query Rewrite Plugin
- Đây là một plugin cho phép bạn tự động sửa hoặc thay thế câu truy vấn SQL trước khi chúng được gửi đến máy chủ để xử lý.
- Query Rewrite Plugin sử dụng khi:
+ Cần chỉnh sửa truy vấn từ ứng dụng mà không can thiệp vào mã nguồn
+ Tối ưu hóa cụ thể
+ Chuyển hướng các truy vấn đã lỗi thời

# 3. InnoDB Cluster
- InnoDB Cluster là một giải pháp High Availability của MySQL bao gồm 3 phần chính:
+ MySQL Server
+ MySQL Shell
+ MySQL Router

- InnoDB Cluster thường tự động relication dữ liệu giữa các node, có cơ chế tự phục hồi khi 1 node lỗi và dựa trên Gruop Replication

# 4. XA Transactions (Distributed Transactions)
- XA Transaction là giao dịch phân tán nhiều hệ thống hoặc nhiều tài nguyên.
- XA Transaction được sử dụng khi một giao dịch cần thực hiện nhiều CSDL hoặc nhiều bảng trong storage engine kahcs nhau
- Cơ chế 2-Pháe Commit:
+ PREPARE: Xác nhận tất cả nơi đều sẵn sàng commit.
+ COMMIT: Nếu tất cả đồng ý 

# 5. Event Scheduler
- Event Scheduler là bộ lập lịch tự động trong MySQL, giúp chạy các lệnh SQL định kỳ như cron job
- Cách bật:
SET GLOBAL event_scheduler = ON;

# 6. Full-Text Search
- Đây là cơ chế tìm kiếm văn bản thông minh trên các cột CHAR, VARCHAR, TEXT.
- Full-Text Search hỗ trợ các tính năng:
+ Tìm kiếm theo từ khóa
+ Hỗ trợ Boolean Mode
+ Tính điểm relevance
- Cách tạo:
CREATE TABLE posts (
  id INT,
  title TEXT,
  FULLTEXT(title)
);

SELECT * FROM posts
WHERE MATCH(title) AGAINST('MySQL' IN NATURAL LANGUAGE MODE);

# 7. Spatial Data Types and Functions
- Dùng để lưu và xử lý dữ liệu không gian như điểm, đường, đa giác.
+ Dữ liệu: GEOMETRY, POINT, LINESTRING, POLYGON,...
+ Hàm xử lý:
    ST_Distance() – Tính khoảng cách.
    ST_Within() – Kiểm tra xem điểm có nằm trong vùng không.
    ST_Contains(), ST_Intersects(), v.v.