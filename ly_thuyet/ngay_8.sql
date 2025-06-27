-- Tối ưu truy vấn CSDL 2
# 1. Tận dụng bộ nhớ đệm (Caching)
- Việc tận dụng bộ nhớ đệm (caching) là một trong những cách tối ưu hiệu suất truy vấn mạnh mẽ nhất
- Nếu truy vấn bị lặp lại nhiều lần sẽ dẫn đến tốn CPU & I/O, tăng độ trễ phản hồi, gây tải lớn lên CSDL

# 2. Sử dụng EXPLAIN ANALYZE (MySQL 8.0+, PostgreSQL)
- Việc sử dụng EXPLAIN ANALYZE nhằm:
+ Phân tích kế hoạch thực thi thực tế của truy vấn SQL
+ Cho biết thời gian thực thi thật, số dòng xử lý và tài nguyên sử dụng tại từng bước
+ So sánh với EXPLAIN thường: EXPLAIN chỉ dự đoán, còn EXPLAIN ANALYZE thực sự chạy truy vấn rồi phân tích.

- Cú pháp trong MySQL 8.0+
EXPLAIN ANALYZE
SELECT * FROM orders WHERE status = 'completed';

-  Cú pháp trong PostgreSQL
EXPLAIN ANALYZE
SELECT * FROM products WHERE price > 1000;

# 3. Phân vùng bảng (Partitioning)
- Phân vùng bảng bằng chia logic một bảng thành nhiều phần nhỏ hơn, nhưng từ phía người dùng vẫn thấy như một bảng duy nhất.
- Truy vấn sẽ chỉ hoạt động trên một hoặc vài phân vùng, thay vì toàn bộ bảng giúp tăng tốc độ đáng kể khi dữ liệu lớn.
- Việc dùng Partitioning giúp:
+ Truy vấn nhanh hơn
+ Quản lý dữ liệu tốt hơn
+ Xóa dữ liệu dễ hơn
+ Hữu ích cho báo cáo, thống kê theo thời gian

# 4. Chuẩn hóa hoặc phi chuẩn hóa schema khi cần
- Chuẩn hóa (Normalization) là quá trình thiết kế CSDL theo các chuẩn NF (Normal Form) như 1NF, 2NF, 3NF… để tránh trùng lặp dữ liệu và đảm bảo toàn vẹn dữ liệu.
- Việc chuẩn hóa giúp:
+ Dữ liệu được tách ra nhiều bảng tránh trung lặp
+ Dễ dàng cập nhật
+ Dễ kiểm soát toàn vẹn dữ liệu

# 5. Chọn kiểu dữ liệu tối ưu
- Việc chọn kiểu dữ liệu hợp lý giúp:
+ Giảm kích thước lưu trữ
+ Tăng tốc truy vấn
+ Giảm chi phí bộ nhớ và I/O
+ Tăng hiệu suất bộ nhớ đệm (cache)

- Nguyên tắc để chọn kiểu dữ liệu:
+ Chọn kích thước nhỏ nhất cần thiết 
+ Chọn kiểu dữ liệu chính xác
+ Dùng kiểu số thay vì chuỗi khi có thể
+ Kiểm tra dữ liệu thực tế

# 6. Sử dụng Window Functions thay vòng lặp
- Window Functions xử lý nhiều dòng liên quan mà không gộp lại
* Cú pháp cơ bản:
<aggregate_function>() OVER (
  PARTITION BY ...
  ORDER BY ...
)

- Các hàm Window Function phổ biến
| Hàm                              | Mô tả                      | Ví dụ                             |
| -------------------------------- | -------------------------- | --------------------------------- |
| `ROW_NUMBER()`                   | Đánh số thứ tự             | STT trong nhóm                    |
| `RANK()` / `DENSE_RANK()`        | Xếp hạng                   | Top sản phẩm bán chạy             |
| `SUM()`, `AVG()`                 | Tổng / trung bình cộng dồn | Doanh thu tích lũy                |
| `LAG()` / `LEAD()`               | Lấy dòng trước / sau       | So sánh doanh thu hôm trước       |
| `FIRST_VALUE()` / `LAST_VALUE()` | Giá trị đầu/cuối           | Lấy đơn hàng đầu tiên trong tháng |

# 7. Tối ưu Transaction ngắn gọn
- Việc tối ưu Transaction ngắn gọn nhằm giảm thời gian giữ lock, tăng hiệu suất, giảm dealock và nâng cao tính nhất quán dữ liệu
- Những nguyên tắc tối ưu Transaction
+ Chỉ bao gồm các thao tác liên quan trực tisp đến tính nhất quán
+ Xử lý dữ liệu đầu vào trước khi bắt đầu Transaction
+ Giữ Transaction càng ngắn càng tốt
+ Chỉ lock những gì cần thiết

# 8. Kiểm tra Slow Query Log
- Slow Query Log Là nhật ký ghi lại các truy vấn mất nhiều thời gian để thực thi hơn ngưỡng cho phép (long_query_time).
- Slow Query Log giúp phát hiện các truy vấn SQL chạy chậm để bạn tối ưu hiệu suất hệ thống.
