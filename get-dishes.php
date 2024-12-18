<?php
// get-dishes.php

include('config.php');

// Lấy danh sách món ăn
$query = "SELECT id, name, quantity FROM dishes"; // Chỉ lấy id, name và quantity
$result = $conn->query($query);

// Trả về dữ liệu món ăn dưới dạng JSON
$dishes = [];
while ($row = $result->fetch_assoc()) {
    $dishes[] = $row;
}

echo json_encode($dishes); // Trả về dữ liệu dưới dạng JSON
?>
