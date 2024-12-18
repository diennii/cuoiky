-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: 
-- Phiên bản máy phục vụ: 8.0.40
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `restaurant_management`

-- Cấu trúc bảng cho bảng `dishes`
--

CREATE TABLE `dishes` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `sold_quantity` int DEFAULT '0',
  `revenue` decimal(10,2) DEFAULT '0.00',
  `category` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `dishes`
--

INSERT INTO `dishes` (`id`, `name`, `description`, `price`, `quantity`, `sold_quantity`, `revenue`, `category`) VALUES
(1, 'Pizza Margherita', 'Pizza truyền thống với sốt cà chua, mozzarella, và các gia vị', 10.99, 2, 2, 21.98, NULL),
(2, 'Spaghetti Bolognese', 'Mì spaghetti với sốt bolognese đậm đà', 12.50, 37, 0, 0.00, NULL),
(3, 'Burger Cheeseburger', 'Burger với phô mai cheddar, thịt bò và rau', 8.75, 94, 0, 0.00, NULL),
(4, 'Caesar Salad', 'Salad với rau diếp, gà nướng, sốt Caesar, và phô mai parmesan', 7.50, 40, 0, 0.00, NULL),
(5, 'Grilled Chicken', 'Gà nướng với gia vị, ăn kèm với rau và cơm', 15.00, 20, 0, 0.00, NULL),
(6, 'Sushi Set', 'Sushi với cá hồi tươi, cơm và rong biển', 18.50, 44, 0, 0.00, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `dish_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `guests` int DEFAULT NULL,
  `order_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `dish_id`, `quantity`, `guests`, `order_date`) VALUES
(68, 1, 4, NULL, '2024-12-16'),
(69, 5, 5, NULL, '2024-12-16'),
(70, 1, 20, NULL, '2024-12-16'),
(76, 5, 2, NULL, '2024-12-17'),
(77, 5, 2, NULL, '2024-12-17'),
(78, 3, 2, NULL, '2024-12-17'),
(79, 4, 4, NULL, '2024-12-17'),
(80, 4, 4, NULL, '2024-12-17'),
(81, 2, 4, NULL, '2024-12-17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sales`
--

CREATE TABLE `sales` (
  `id` int NOT NULL,
  `dish_id` int NOT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `sale_date` date NOT NULL,
  `order_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `sales`
--

INSERT INTO `sales` (`id`, `dish_id`, `quantity`, `total_price`, `sale_date`, `order_id`) VALUES
(1, 1, 2, 21.98, '2024-12-16', NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dish_id` (`dish_id`);

--
-- Chỉ mục cho bảng `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dish_id` (`dish_id`),
  ADD KEY `fk_order_id` (`order_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `dishes`
--
ALTER TABLE `dishes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT cho bảng `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`id`);

--
-- Các ràng buộc cho bảng `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`id`);
COMMIT;
-- 4. Cập nhật số lượng món ăn trong kho sau mỗi lần bán
UPDATE `dishes`
SET `quantity` = `quantity` - 1, `sold_quantity` = `sold_quantity` + 1, `revenue` = `revenue` + `price`
WHERE `id` = [dish_id];

-- 5. Lấy thông tin doanh thu từng món ăn
SELECT `dishes`.`name`, SUM(`sales`.`total_price`) AS `total_revenue`
FROM `sales`
JOIN `dishes` ON `sales`.`dish_id` = `dishes`.`id`
GROUP BY `dishes`.`name`;

-- 6. Lấy thông tin số lượng món ăn đã bán trong ngày
SELECT `dishes`.`name`, SUM(`sales`.`quantity`) AS `total_sold`
FROM `sales`
JOIN `dishes` ON `sales`.`dish_id` = `dishes`.`id`
WHERE `sales`.`sale_date` = CURDATE()
GROUP BY `dishes`.`name`;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
