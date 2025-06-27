# 1. Master-Slave (Replication truyền thống)
- Master-Slave là mô hình nhân bản dữ liệu một chiều, trong đó Master xử lý ghi, Slave nhận dữ liệu đọc-only từ master
- Ưu điểm
+ Tăng khả năng mở rộng
+ Dùng để backup, kiểm thử
- Nhược điểm
+ Không tự động failover 
+ Có độ trễ

#  2. Các Biến Môi Trường Cấu Hình MySQL Server

* Tối ưu hiệu xuất:
| Biến                             | Mô tả                                       |
| -------------------------------- | ------------------------------------------- |
| `innodb_buffer_pool_size`        | Dung lượng RAM dùng để cache dữ liệu InnoDB |
| `query_cache_size`               | Cache kết quả SELECT (deprecated từ 5.7)    |
| `max_connections`                | Số lượng kết nối đồng thời tối đa           |
| `thread_cache_size`              | Tăng tốc tạo thread mới                     |
| `table_open_cache`               | Cache bảng đang mở                          |
| `innodb_flush_log_at_trx_commit` | Tối ưu ghi log InnoDB                       |

*  Bảo mật:
| Biến                       | Mô tả                                 |
| -------------------------- | ------------------------------------- |
| `secure_file_priv`         | Giới hạn thư mục dùng cho `LOAD DATA` |
| `local_infile`             | Cho phép đọc file từ client (nên tắt) |
| `validate_password_policy` | Chính sách mật khẩu mạnh              |
| `skip_name_resolve`        | Tăng hiệu suất & tránh DNS spoof      |

*  Log và giám sát:
| Biến                 | Mô tả                                   |
| -------------------- | --------------------------------------- |
| `general_log`        | Ghi tất cả truy vấn                     |
| `slow_query_log`     | Ghi truy vấn chạy chậm                  |
| `log_error`          | Ghi lỗi hệ thống                        |
| `performance_schema` | Cung cấp thống kê hệ thống chi tiết     |
| `binlog_format`      | Dạng ghi binlog (ROW, STATEMENT, MIXED) |

# 3. Replication (Nhân bản CSDL)
- Là quá trình tự động sao chép dữ liệu từ máy chủ này sang máy chủ khác
- Các dạng replication:
+ Asynchronous: Slave không đồng bộ tức thì.
+ Semi-synchronous: Master chờ ít nhất 1 Slave xác nhận.
+ Group Replication: Nhiều node đồng bộ dùng cho InnoDB Cluster.
- Mục đích:
+ Mở rộng đọc
+ Dự phòng
+ Phân tích, backup

# 4. MySQL Cluster
- Là một hệ thống CSDL phân tán thật sự, có khả năng tự động phân mảnh dữ liệu (sharding), tự phục hồi khi node bị lỗi và hỗ trợ Realtime, độ trễ thấp.
- Thành phần:
+ Data Node: lưu dữ liệu.
+ SQL Node: giao tiếp SQL.
+ Management Node: điều phối.

# 5. Proxy và Middleware
- Proxy và Middleware được dùng để cân bằng tải truy vấn, chuyển hướng truy vấn đọc/ghi và tăng HA
- Một số công cụ phổ biến:
+ Proxy SQL
+ MaxScale
+ MySQL Router

# 6. InnoDB Cluster
- Một giải pháp chính thức từ Oracle để triển khai MySQL phân tán có độ sẵn sàng cao (HA).
- Thành phần:
+ MySQL Server (Group Replication): đồng bộ dữ liệu.
+ MySQL Shell: cấu hình, quản lý cluster.
+ MySQL Router: phân tuyến truy vấn đến node phù hợp.
- Ưu điểm:
+ Dễ triển khai hơn MySQL Cluster
+ Tự động Failover
+ Hỗ trợ multi-primary (nhiều node ghi) hoặc single-primary.