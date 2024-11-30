CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Address VARCHAR(255),
    Phone VARCHAR(15)
);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalPrice DECIMAL(10, 2),
    DiscountID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Discounts (
    DiscountID INT AUTO_INCREMENT PRIMARY KEY,
    Code VARCHAR(50) UNIQUE NOT NULL,
    DiscountAmount DECIMAL(10, 2) NOT NULL,
    ExpirationDate DATE NOT NULL
);

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Shipments (
    ShipmentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ShipmentDate DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Thêm người dùng
INSERT INTO Users (Name, Email, Address, Phone)
VALUES 
('Nguyen Van A', 'a@example.com', '123 ABC Street', '0123456789'),
('Tran Thi B', 'b@example.com', '456 DEF Avenue', '0987654321');

-- Thêm danh mục sản phẩm
INSERT INTO Categories (Name)
VALUES 
('Sports Shoes'),
('Casual Shoes');

-- Thêm sản phẩm
INSERT INTO Products (Name, Price, Stock, CategoryID)
VALUES 
('Nike Air Max', 120.00, 50, 1),
('Adidas Ultraboost', 150.00, 30, 1),
('Vans Old Skool', 70.00, 40, 2);

-- Thêm mã giảm giá
INSERT INTO Discounts (Code, DiscountAmount, ExpirationDate)
VALUES 
('DISCOUNT10', 10.00, '2024-12-31'),
('DISCOUNT20', 20.00, '2024-12-31');

-- Thêm đơn hàng
INSERT INTO Orders (UserID, TotalPrice, DiscountID)
VALUES 
(1, 230.00, 1);

-- Thêm chi tiết đơn hàng
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 2, 120.00),
(1, 2, 1, 150.00);

-- Thêm thanh toán
INSERT INTO Payments (OrderID, Amount, PaymentMethod)
VALUES 
(1, 230.00, 'Credit Card');

-- Thêm đánh giá
INSERT INTO Reviews (ProductID, UserID, Rating, Comment)
VALUES 
(1, 1, 5, 'Great product!'),
(2, 2, 4, 'Comfortable but a bit pricey.');
