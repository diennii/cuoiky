// Hàm cập nhật doanh thu trên giao diện

// Hàm cập nhật doanh thu trên giao diện//+
function updateDailyRevenue(revenue) {
    const revenueElement = document.querySelector('.revenue');
 
    revenueElement.textContent = `${revenue.toFixed(2)} VND`;//+
}


// Lắng nghe sự kiện khi form được submit
document.getElementById('updateFoodForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const dishId = document.getElementById('dishName').value;
    const quantity = document.getElementById('quantity').value;
    const operation = document.querySelector('input[name="operation"]:checked').value;

    try {
        const response = await fetch('/update-food.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ dishId, quantity, operation })
        });

        const data = await response.json();

        // Kiểm tra nếu có lỗi trả về từ server
        if (data.error) {
            alert(data.error);  // Nếu có lỗi từ server, hiển thị thông báo
        } else {
            // Cập nhật doanh thu và số lượng sau khi thao tác thành công
            updateDailyRevenue(data.revenue);  // Cập nhật doanh thu mới
            updateMenuItem(dishId, data.newQuantity);  // Cập nhật số lượng món ăn trong menu
        }
    } catch (error) {
        console.error('Lỗi khi cập nhật món ăn:', error);
    }
});