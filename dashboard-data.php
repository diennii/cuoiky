<?php
include('config.php');

// Tính doanh thu cho từng món ăn
$query = "
    SELECT dishes.name, SUM(dishes.price * orders.quantity) AS total_revenue
    FROM orders
    JOIN dishes ON orders.dish_id = dishes.id
    WHERE orders.order_date = CURDATE()
    GROUP BY dishes.name
";
$result = $conn->query($query);

// Nếu có kết quả trả về
$dailyRevenue = 0;
$foodRevenues = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $foodRevenues[] = $row;
        $dailyRevenue += $row['total_revenue'];  // Tổng doanh thu hôm nay
    }
} else {
    $dailyRevenue = 0;
}

?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu Hôm Nay</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .dashboard-container {
            background-color: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .dashboard-container h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #3498db;
        }
        .dashboard-container p {  
            font-size: 18px;
            color: #555;
        }
        .dashboard-container .revenue {
            font-size: 32px;
            font-weight: bold;
            color: #e74c3c;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h1>Doanh Thu Hôm Nay</h1>
        <p>Doanh thu từ các món ăn đã bán:</p>
        <p class="revenue"><?php echo number_format($dailyRevenue, 2); ?> VND</p>

        <!-- Bảng doanh thu theo từng món ăn -->
        <table>
            <thead>
                <tr>
                    <th>Tên Món Ăn</th>
                    <th>Doanh Thu</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($foodRevenues as $food) { ?>
                    <tr>
                        <td><?php echo htmlspecialchars($food['name']); ?></td>
                        <td><?php echo number_format($food['total_revenue'], 2); ?> VND</td>
                    </tr>
                <?php } ?>
            </tbody>
        </table>
    </div>
</body>
</html>
