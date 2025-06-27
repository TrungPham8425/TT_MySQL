-- 1. Tạo bảng
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    category_id INT,
    price DECIMAL(18,2) NOT NULL,
    stock_quantity INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL
    -- Pending, Shipped, Cancelled
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 2. Tạo chỉ mục tối ưu hóa
CREATE INDEX idx_orders_status_orderdate ON Orders(status, order_date DESC);
CREATE INDEX idx_orderitems_orderid_productid ON OrderItems(order_id, product_id);
CREATE INDEX idx_products_categoryid_price_name ON Products(category_id, price, name, product_id);

-- 3. Truy vấn tối ưu hóa
-- a. Truy vấn JOIN chỉ lấy cột cần thiết
SELECT Orders.order_id, Orders.order_date, OrderItems.product_id, OrderItems.quantity
FROM Orders
JOIN OrderItems ON Orders.order_id = OrderItems.order_id
WHERE Orders.status = 'Shipped'
ORDER BY Orders.order_date DESC;

-- b. So sánh JOIN vs Subquery
-- JOIN (tối ưu hơn)
SELECT p.product_id, p.name, c.name AS category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;

-- Subquery (kém tối ưu hơn)
SELECT product_id, name,
  (SELECT name FROM Categories WHERE category_id = p.category_id) AS category_name
FROM Products p;

-- c. Lấy 10 sản phẩm mới nhất trong danh mục 'Electronics', còn hàng
SELECT p.product_id, p.name, p.price, p.stock_quantity
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.name = 'Electronics' AND p.stock_quantity > 0
ORDER BY p.created_at DESC
LIMIT 10;

-- d. Truy vấn sử dụng Covering Index
SELECT product_id, name, price 
FROM Products 
WHERE category_id = 3 
ORDER BY price ASC 
LIMIT 20;

-- e. Tối ưu truy vấn tính doanh thu theo tháng
-- Giả sử doanh thu là tổng unit_price * quantity của các đơn hàng đã 'Shipped'
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(oi.unit_price * oi.quantity) AS revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.status = 'Shipped' AND o.order_date >= '2024-01-01' AND o.order_date < '2025-01-01'
GROUP BY month
ORDER BY month;

-- f. Tách truy vấn lớn thành nhiều bước nhỏ
-- Bước 1: Lọc đơn hàng có sản phẩm đắt tiền (>1M)
SELECT DISTINCT o.order_id
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE oi.unit_price > 1000000;

-- Bước 2: Tính tổng số lượng bán ra của các đơn hàng này
SELECT SUM(oi.quantity) AS total_quantity
FROM OrderItems oi
WHERE oi.order_id IN (
    SELECT DISTINCT o.order_id
    FROM Orders o
    JOIN OrderItems oi2 ON o.order_id = oi2.order_id
    WHERE oi2.unit_price > 1000000
);

-- g. Truy vấn top 5 sản phẩm bán chạy nhất trong 30 ngày gần nhất
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_sold
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY AND o.status = 'Shipped'
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;
