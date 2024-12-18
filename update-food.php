<?php
include('config.php');

// Nhận dữ liệu từ yêu cầu POST
$data = json_decode(file_get_contents('php://input'), true);

$dishId = $data['dishId'];
$quantity = $data['quantity'];
$operation = $data['operation'];

if ($operation === 'add') {
    // Thêm món ăn vào kho (tăng số lượng)
    $query = "SELECT * FROM dishes WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $dishId);
    $stmt->execute();
    $result = $stmt->get_result();
    $dish = $result->fetch_assoc();

    $newQuantity = $dish['quantity'] + $quantity;
    $updateQuery = "UPDATE dishes SET quantity = ? WHERE id = ?";
    $stmt = $conn->prepare($updateQuery);
    $stmt->bind_param("ii", $newQuantity, $dishId);
    $stmt->execute();

    // Không cập nhật doanh thu khi thêm món ăn vào kho
    $revenue = 0;
    $newQuantity = $newQuantity; // Đảm bảo trả về số lượng mới
} else if ($operation === 'serve') {
    // Giảm số lượng món ăn (số lượng bán ra)
    $query = "SELECT * FROM dishes WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $dishId);
    $stmt->execute();
    $result = $stmt->get_result();
    $dish = $result->fetch_assoc();

    if ($dish['quantity'] < $quantity) {
        // Nếu không đủ số lượng trong kho
        echo json_encode(['error' => 'Không đủ số lượng trong kho']);
        exit;
    }

    $newQuantity = $dish['quantity'] - $quantity;
    $updateQuery = "UPDATE dishes SET quantity = ? WHERE id = ?";
    $stmt = $conn->prepare($updateQuery);
    $stmt->bind_param("ii", $newQuantity, $dishId);
    $stmt->execute();

    // Tạo đơn hàng trong bảng orders
    $orderDate = date('Y-m-d');
    $orderQuery = "INSERT INTO orders (dish_id, quantity, order_date) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($orderQuery);
    $stmt->bind_param("iis", $dishId, $quantity, $orderDate);
    $stmt->execute();

    // Tính doanh thu
    $revenue = $dish['price'] * $quantity;
}

// Trả về kết quả JSON
echo json_encode(['revenue' => $revenue, 'newQuantity' => $newQuantity]);
?>