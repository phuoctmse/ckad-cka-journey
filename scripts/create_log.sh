#!/bin/bash

# Thiết lập đường dẫn thư mục và file
LOG_DIR="daily-logs"
TEMPLATE_FILE="$LOG_DIR/TEMPLATE.md"
TODAY=$(date +"%Y-%m-%d")
NEW_LOG_FILE="$LOG_DIR/$TODAY.md"

# Chuyển đến thư mục gốc của project (nơi chứa script)
cd "$(dirname "$0")/.." || exit

# Kiểm tra xem file ngày hôm nay đã tồn tại chưa
if [ -f "$NEW_LOG_FILE" ]; then
    echo "⚠️  Báo cáo cho ngày hôm nay ($NEW_LOG_FILE) đã tồn tại!"
    exit 1
fi

# Bắt đầu hỏi người dùng nhập dưới dạng ngôn ngữ tự nhiên
echo "📝 BẮT ĐẦU NHẬP BÁO CÁO NGÀY $TODAY (Nhấn Enter để qua câu tiếp theo):"
echo "------------------------------------------------------"

read -p "🧠 Hôm nay bạn đã học được gì? : " LEARNED
read -p "🚧 Có khó khăn / vướng mắc gì không? : " BLOCKERS
read -p "📅 Kế hoạch ngày mai là gì? : " TOMORROW

# Điền nội dung mặc định nếu người dùng để trống
LEARNED=${LEARNED:-"Không ghi chú gì thêm."}
BLOCKERS=${BLOCKERS:-"Không có vướng mắc."}
TOMORROW=${TOMORROW:-"Tiếp tục theo lộ trình học tập."}

# Tạo file markdown mới bằng cách chèn trực tiếp nội dung vừa nhập
cat <<EOF > "$NEW_LOG_FILE"
# Báo cáo ngày: $TODAY

## 🧠 Đã học được gì
- $LEARNED

## 🚧 Khó khăn / Vướng mắc
- $BLOCKERS

## 📅 Kế hoạch ngày mai
- $TOMORROW
EOF

echo "------------------------------------------------------"
echo "✅ Đã tạo thành công nhật ký cho ngày hôm nay: $NEW_LOG_FILE"
