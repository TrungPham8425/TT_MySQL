-- 1. Tạo bảng chuẩn hóa
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT,
    created_at TIMESTAMP NOT NULL,
    likes INT DEFAULT 0,
    -- hashtags sẽ chuẩn hóa ở bảng riêng
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Follows (
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id),
    FOREIGN KEY (followee_id) REFERENCES Users(user_id)
);

-- Bảng PostViews phân vùng theo tháng
CREATE TABLE PostViews (
    view_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    viewer_id INT NOT NULL,
    view_time TIMESTAMP NOT NULL,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (viewer_id) REFERENCES Users(user_id)
)
PARTITION BY RANGE (YEAR(view_time)*100 + MONTH(view_time)) (
    PARTITION p202401 VALUES LESS THAN (202402),
    PARTITION p202402 VALUES LESS THAN (202403),
    PARTITION p202403 VALUES LESS THAN (202404),
    PARTITION p202404 VALUES LESS THAN (202405),
    PARTITION p202405 VALUES LESS THAN (202406),
    PARTITION p202406 VALUES LESS THAN (202407),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

-- Bảng chuẩn hóa hashtags
CREATE TABLE Hashtags (
    hashtag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE PostHashtags (
    post_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (post_id, hashtag_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (hashtag_id) REFERENCES Hashtags(hashtag_id)
);

-- Bảng phi chuẩn hóa cho dashboard
CREATE TABLE PopularPostsDaily (
    post_id INT,
    post_date DATE,
    likes INT,
    views INT,
    PRIMARY KEY (post_id, post_date)
);

-- 2. Truy vấn top 10 bài viết được thích nhiều nhất hôm nay (có thể cache)
SELECT post_id, likes
FROM Posts
WHERE DATE(created_at) = CURDATE()
ORDER BY likes DESC
LIMIT 10;
-- Gợi ý: cache kết quả này ở application layer hoặc MEMORY TABLE

-- 3. EXPLAIN ANALYZE truy vấn hashtags
EXPLAIN ANALYZE SELECT * FROM Posts 
WHERE hashtags LIKE '%fitness%' 
ORDER BY created_at DESC 
LIMIT 20;
-- Bottleneck: Không có index cho LIKE '%...%', nên sẽ scan toàn bảng. Đề xuất chuẩn hóa hashtags và tạo index trên PostHashtags.

-- 4. Truy vấn thống kê số lượt xem mỗi tháng trong 6 tháng gần nhất
SELECT DATE_FORMAT(view_time, '%Y-%m') AS month, COUNT(*) AS view_count
FROM PostViews
WHERE view_time >= DATE_FORMAT(CURDATE() - INTERVAL 5 MONTH, '%Y-%m-01')
GROUP BY month
ORDER BY month DESC;

-- 5. Window function: Tổng view và xếp hạng bài viết mỗi ngày
SELECT post_id, view_date, view_count, RANK() OVER (PARTITION BY view_date ORDER BY view_count DESC) AS rnk
FROM (
    SELECT post_id, DATE(view_time) AS view_date, COUNT(*) AS view_count
    FROM PostViews
    GROUP BY post_id, view_date
) t;

-- Truy vấn top 3 bài viết mỗi ngày
SELECT * FROM (
    SELECT post_id, view_date, view_count, RANK() OVER (PARTITION BY view_date ORDER BY view_count DESC) AS rnk
    FROM (
        SELECT post_id, DATE(view_time) AS view_date, COUNT(*) AS view_count
        FROM PostViews
        GROUP BY post_id, view_date
    ) t
) ranked
WHERE rnk <= 3;

-- 6. Stored procedure cập nhật lượt thích (likes) khi user like
DELIMITER //
CREATE PROCEDURE LikePost(IN p_user_id INT, IN p_post_id INT)
BEGIN
    -- Giả sử có bảng PostLikes(user_id, post_id)
    IF NOT EXISTS (SELECT 1 FROM PostLikes WHERE user_id = p_user_id AND post_id = p_post_id) THEN
        INSERT INTO PostLikes(user_id, post_id) VALUES (p_user_id, p_post_id);
        UPDATE Posts SET likes = likes + 1 WHERE post_id = p_post_id;
    END IF;
END //
DELIMITER ;

-- 7. Kiểm tra Slow Query Log
-- Bật slow_query_log:
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1; -- log truy vấn >1s
-- Xem log: SHOW VARIABLES LIKE 'slow_query_log_file';
-- Phân tích log để tìm truy vấn chậm, ví dụ:
-- SELECT * FROM Posts WHERE hashtags LIKE '%fitness%';
-- Cải thiện: chuẩn hóa hashtags, tạo index, tránh LIKE '%...%'.

-- 8. Sử dụng OPTIMIZER_TRACE
SET optimizer_trace = 'enabled=on';
SELECT p.post_id, u.username
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
WHERE p.created_at >= CURDATE() - INTERVAL 7 DAY
ORDER BY p.created_at DESC;
SELECT * FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE;
-- Phân tích JSON để hiểu kế hoạch truy vấn.

-- 9. Rà soát kiểu dữ liệu
-- Nếu PostViews < 2 tỷ dòng, có thể dùng INT thay BIGINT cho view_id.
-- VARCHAR(255) nên giảm cho hashtags, username.
-- Dùng TIMESTAMP thay DATETIME nếu không cần năm < 1970 hoặc > 2038. 