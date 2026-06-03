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

# Chép nội dung từ TEMPLATE và thay thế biến {{DATE}} bằng ngày hiện tại
cp "$TEMPLATE_FILE" "$NEW_LOG_FILE"

# Lệnh sed khác nhau một chút giữa Mac (BSD) và Linux (GNU), ở đây dùng hướng tương thích bash tiêu chuẩn
if sed --version >/dev/null 2>&1; then
  sed -i "s/{{DATE}}/$TODAY/g" "$NEW_LOG_FILE"
else
  sed -i '' "s/{{DATE}}/$TODAY/g" "$NEW_LOG_FILE"
fi

echo "✅ Đã tạo thành công nhật ký cho ngày hôm nay: $NEW_LOG_FILE"
