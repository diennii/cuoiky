from flask import Flask, render_template
import mysql.connector

# Khởi tạo ứng dụng Flask
app = Flask(__name__)

# Hàm kết nối với cơ sở dữ liệu MySQL
def get_db_connection():
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='vien ',  # Thay thế bằng mật khẩu của bạn
        database='database'   # Thay thế bằng tên cơ sở dữ liệu của bạn
    )
    return connection

# Trang chủ
@app.route('/')
def index():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM your_table')  # Thay thế 'your_table' bằng tên bảng của bạn
    data = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('index.html', data=data)

# Chạy ứng dụng Flask
if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=5001)
