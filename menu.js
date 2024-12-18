// Tải dữ liệu món ăn từ API và cập nhật số lượng
async function loadMenu() {
    try {
        const response = await fetch('get-dishes.php');  // Lấy dữ liệu từ API
        const dishes = await response.json();  // Chuyển đổi dữ liệu thành JSON

        // Lặp qua các món ăn và cập nhật chúng trong HTML
        dishes.forEach(dish => {
            // Lấy phần tử <span> theo ID, tương ứng với id của món ăn
            const dishElement = document.querySelector(`#available-${dish.id}`);

            if (dishElement) {
                // Cập nhật số lượng món ăn vào phần tử <span>
                dishElement.textContent = `Available: ${dish.quantity}`; // Hiển thị số lượng thực tế từ cơ sở dữ liệu
            }
        });
    } catch (error) {
        console.error('Error loading menu:', error);
    }
}

// Gọi hàm loadMenu khi trang được tải
document.addEventListener('DOMContentLoaded', loadMenu);
