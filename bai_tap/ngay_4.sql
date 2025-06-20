DROP DATABASE ngay_4;

-- 1. Tạo cơ sở dữ liệu 
CREATE DATABASE IF NOT EXISTS ngay_4;
USE ngay_4;

-- 2. Tạo bảng Students
CREATE TABLE ngay_4.Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE
);

-- 3. Tạo bảng Courses
CREATE TABLE ngay_4.Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    price INT CHECK (price >= 0)
);

-- 4. Tạo bảng Enrollments
CREATE TABLE ngay_4.Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES ngay_4.Students(student_id),
    FOREIGN KEY (course_id) REFERENCES ngay_4.Courses(course_id)
);

-- 5. Thêm cột status vào bảng Enrollments với giá trị mặc định là 'active'
ALTER TABLE ngay_4.Enrollments
ADD COLUMN status VARCHAR(20) DEFAULT 'active';

-- 6. Tạo VIEW hiển thị danh sách sinh viên và tên khóa học họ đã đăng ký
CREATE VIEW ngay_4.StudentCourseView AS
SELECT s.student_id, s.full_name, c.title AS course_title
FROM ngay_4.Students s
JOIN ngay_4.Enrollments e ON s.student_id = e.student_id
JOIN ngay_4.Courses c ON e.course_id = c.course_id;

-- 7. Tạo chỉ mục trên cột title của bảng Courses
CREATE INDEX idx_courses_title ON ngay_4.Courses(title);