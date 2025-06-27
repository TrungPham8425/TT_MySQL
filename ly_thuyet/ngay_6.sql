# 1. InnoDB vs MyISAM vs Others

* InnoDB
Hỗ trợ Transaction (BEGIN, COMMIT, ROLLBACK), khóa ngoại, khóa từng dòng(Row-level locking), khôi phục lỗi và sử dụng MVCC

* MyISAM
Đối với MyISAM sẽ không hỗ trợ Transaction, không hỗ trợ khóa ngoại, không có các crash recovery tốt như InnoDB nhưng lại nhanh với SELECT-heavy workloads

* Một số Engine khác
 MEMORY: Lưu dữ liệu trong RAM → cực nhanh nhưng volatile 
 CSV: Lưu bảng dạng file CSV                           
 ARCHIVE: Lưu trữ chỉ để đọc (log, dữ liệu lâu dài)        
 FEDERATED: Truy vấn từ server khác                          

# 2. Transaction + Các loại transaction

Transaction là các nhóm cac thao tác sql được thực hiện như một đơn vị duy nhất

Để dảm bảo tính toàn vẹn và đáng tin cậy của transaction ta có 4 nguyên tắc viết tắt là ACID
+ Atomicity: tất cả hoặc không có gì xảy ra
+ Consistency: dữ liệu luôn đúng
+ Isolation: các transaction không ảnh hưởng nhau
+ Durability: dữ liệu không mất sau khi commit

Cấu trúc của một Transaction
START TRANSACTION;  -- hoặc BEGIN;
-- Các câu lệnh SQL
COMMIT;             -- Lưu thay đổi
-- hoặc
ROLLBACK;           -- Hủy thay đổi nếu có lỗi


Các cấp độ Transaction
| Isolation Level      | Dirty Read | Non-repeatable Read | Phantom Read |
| -------------------- | ---------- | ------------------- | ------------ |
| **READ UNCOMMITTED** |  Có       |  Có                |  Có         |
| **READ COMMITTED**   |  Không    |  Có                |  Có         |
| **REPEATABLE READ**  |  Không    |  Không             |  Có         |
| **SERIALIZABLE**     |  Không    |  Không             |  Không      |

# 3. Chống Deadlock

Deadlock (bế tắc) xảy ra khi hai (hoặc nhiều) transaction chờ nhau để giải phóng tài nguyên (lock), nhưng không ai nhường ai và có thể kẹt vĩnh viễn nếu không xử lý.

Cách chống Deadlock 
+ Truy cập tài nguyên theo cùng thứ tự
+ Transation ngắn gọn và nhanh chóng
+ Sử dụng khóa rõ ràng với SELECT ... FOR UPDATE
+ Sử dụng LOCK IN SHARE MODE hoặc FOR UPDATE hợp lý
+ Xử lý lỗi dealock khi phát sinh

# 4. MVCC

MVCC là cơ chế quản lý đồng thời trong cơ sở dữ liệu, cho phép nhiều transaction thực thi cùng lúc mà không bị chặn nhau, bằng cách duy trì nhiều phiên bản của dữ liệu.

MVVC giúp tăng hiệu năng đọc, tránh xung đột giữa đọc và ghi cuối cùng là đảm bảo tính Isolation cho transaction

Cách hoạt động của MVVC: 
+ Mỗi row trong bảng sẽ lưu ID của transaction cuối cùng của dòng ghi và trỏ tới bản sao cũ
+ Sau khi SELECT hệ thông sẽ so sánh ID của transaction đang đọc với các dòng và chỉ hiển thị dòng hợp lệ tại thời điểm bắt đầu

# 5.  CTE + Common Table Expression

CTE là một biểu thức bảng tạm thời, được định nghĩa bằng từ khóa WITH, và có thể được dùng như một bảng ảo trong cùng truy vấn.
Nó giúp viết các truy vấn dễ hiểu hơn, tái sử dụn logic và hỗ trợ đệ quy


