-- # 1. IN
-- Dùng để kiểm tra xem một giá trị có nằm trong danh sách các giá trị không 
-- VD: 
-- SELECT * FROM customers WHERE city IN ('Hanoi', 'Ho Chi Minh');

-- # 2. BETWEEN
-- Dùng để kiểm tra xem một giá trị có nằm trong một khoảng giá trị không bao gồm cả giá trị đầu và cuối
-- VD: 
-- SELECT * FROM customers WHERE city IN ('Hanoi', 'Ho Chi Minh');

-- # 3. Aliases
-- Dùng để đặt tên tạm cho bảng hoặc cột để câu lệnh gọn hơn, dễ đọc hơn
-- VD: 
-- SELECT c.name AS customer_name
-- FROM customers AS c;

-- # 4. Joins
-- Dùng để kết hợp các hàng từ hai bảng hoặc nhiều bảng dựa trên cột chung
-- Có nhiều loại JOIN như INNER JOIN, LEFT JOIN, RIGHT JOIN, CROSS JOIN, Self join

-- * INNER JOIN:
-- Dùng để trả về các hàng có giá trị khớp nhau ở cả hai bảng
-- VD: 
-- SELECT customers.name, orders.total_amount
-- FROM customers
-- INNER JOIN orders ON customers.customer_id = orders.customer_id;

-- * LEFT JOIN
-- Dùng để trả về tất cả các hàng từ bảng bên trái và các hàng khớp từ bảng bên phải, nếu không có thì sẽ là NULL
-- VD: 
-- SELECT customers.name, orders.total_amount
-- FROM customers
-- LEFT JOIN orders ON customers.customer_id = orders.customer_id;

-- * RIGHT JOIN
-- Dùng để trả về tất cả các hàng tử bên phải và các hàng khớp từ bảng bên trái, nếu không có giá trị sẽ trả về NULL
-- VD: 
-- SELECT customers.name, orders.total_amount
-- FROM customers
-- RIGHT JOIN orders ON customers.customer_id = orders.customer_id;

-- * CROSS JOIN
-- Dùng để trả về mỗi hàng từ bảng A kết hợp với mỗi hàng từ bảng 
-- VD: 
-- SELECT a.name, b.name
-- FROM employees a
-- CROSS JOIN departments b;

-- * Self JOIN
-- Dùng để join một bảng với chính nó thường dùng để tìm mối quan hệ giữa các hàng trong một bảng
-- VD: 
-- SELECT e1.name AS employee, e2.name AS manager
-- FROM employees e1
-- JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- # 5. UNION
-- Dùng gộp kết quả từ nhiều truy vấn và loại bỏ trung lặp
-- VD: 
-- SELECT name FROM customers
-- UNION
-- SELECT name FROM suppliers;

-- # 6. GROUP BY
-- Dùng để nhóm các hàng cùng giá trị để dùng hàm khác tổng hợp
-- VD: 
-- SELECT city, COUNT(*) AS total_customers
-- FROM customers
-- GROUP BY city;

-- # 7. HAVING
-- Dùng lọc các nhóm sau khi đã GROUP BY nó giống với WHERE nhưng dùng với nhóm
-- VD: 
-- SELECT city, COUNT(*) AS total_customers
-- FROM customers
-- GROUP BY city
-- HAVING COUNT(*) > 2;
