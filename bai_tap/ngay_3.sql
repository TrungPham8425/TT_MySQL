-- Tạo database
CREATE DATABASE ngay_3;
USE ngay_3;
SHOW TABLES;

-- Tạo bảng Candidates
CREATE TABLE ngay_3.Candidates (
    candidate_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    years_exp INT,
    expected_salary INT
);

-- Tạo bảng Jobs
CREATE TABLE ngay_3.Jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    department VARCHAR(100),
    min_salary INT,
    max_salary INT
);

-- Tạo bảng Applications
CREATE TABLE ngay_3.Applications (
    app_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    job_id INT,
    apply_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

-- Chèn dữ liệu vào bảng
INSERT INTO ngay_3.Candidates (full_name, email, phone, years_exp, expected_salary) VALUES
('Nguyen Van A', 'a.nguyen@example.com', '0901234567', 3, 1200),
('Tran Thi B', 'b.tran@example.com', '0902345678', 5, 1500),
('Le Van C', 'c.le@example.com', '0903456789', 2, 1000);

INSERT INTO ngay_3.Jobs (title, department, min_salary, max_salary) VALUES
('Software Engineer', 'IT', 1000, 2000),
('HR Specialist', 'Human Resources', 800, 1500),
('Marketing Executive', 'Marketing', 900, 1600);

INSERT INTO ngay_3.Applications (candidate_id, job_id, apply_date, status) VALUES
(1, 1, '2025-06-18', 'Pending'),
(2, 2, '2025-06-19', 'Accepted'),
(3, 1, '2025-06-20', 'Rejected');

-- 1. Tìm các ứng viên đã từng ứng tuyển vào ít nhất một công việc thuộc phòng ban "IT"
SELECT DISTINCT c.full_name
FROM ngay_3.Candidates c
JOIN ngay_3.Applications a ON c.candidate_id = a.candidate_id
JOIN ngay_3.Jobs j ON a.job_id = j.job_id
WHERE j.department = 'IT';

-- 2. Liệt kê các công việc mà mức lương tối đa lớn hơn mức lương mong đợi của bất kỳ ứng viên nào
-- Sử dụng ANY
SELECT j.job_id, j.title, j.department, j.min_salary, j.max_salary
FROM ngay_3.Jobs j
WHERE j.max_salary > ANY (
    SELECT c.expected_salary 
    FROM ngay_3.Candidates c
);

-- 3. Liệt kê các công việc mà mức lương tối thiểu lớn hơn mức lương mong đợi của tất cả ứng viên
SELECT j.job_id, j.title, j.department, j.min_salary, j.max_salary
FROM ngay_3.Jobs j
WHERE j.min_salary > ALL (
    SELECT c.expected_salary 
    FROM ngay_3.Candidates c
);

-- 4. Tạo bảng ShortlistedCandidates và chèn dữ liệu
-- Tạo bảng ShortlistedCandidates
CREATE TABLE ngay_3.ShortlistedCandidates (
    candidate_id INT,
    job_id INT,
    selection_date DATE,
    PRIMARY KEY (candidate_id, job_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

--Chèn vào bảng ShortlistedCandidates những ứng viên có trạng thái 'Accepted'
INSERT INTO ngay_3.ShortlistedCandidates (candidate_id, job_id, selection_date)
SELECT a.candidate_id, a.job_id, CURDATE()
FROM ngay_3.Applications a
WHERE a.status = 'Accepted';

-- 5. Hiển thị danh sách ứng viên với đánh giá mức kinh nghiệm
SELECT 
    c.candidate_id,
    c.full_name,
    c.years_exp,
    CASE 
        WHEN c.years_exp < 1 THEN 'Fresher'
        WHEN c.years_exp BETWEEN 1 AND 3 THEN 'Junior'
        WHEN c.years_exp BETWEEN 4 AND 6 THEN 'Mid-level'
        WHEN c.years_exp > 6 THEN 'Senior'
        ELSE 'Unknown'
    END AS experience_level
FROM ngay_3.Candidates c;

-- 6. Liệt kê tất cả các ứng viên, thay NULL phone bằng 'Chưa cung cấp'
SELECT 
    c.candidate_id,
    c.full_name,
    c.email,
    COALESCE(c.phone, 'Chưa cung cấp') AS phone,
    c.years_exp,
    c.expected_salary
FROM ngay_3.Candidates c;

-- 7. Tìm các công việc có mức lương tối đa không bằng mức lương tối thiểu và mức lương tối đa >= 1000
SELECT j.job_id, j.title, j.department, j.min_salary, j.max_salary
FROM ngay_3.Jobs j
WHERE j.max_salary != j.min_salary 
  AND j.max_salary >= 1000;
