#!/usr/bin/env bash
# =====================================================================
# configmap-demo.sh  -  xem tận mắt ConfigMap env var / volume / subPath
#                       phản ứng thế nào khi ConfigMap bị sửa
# =====================================================================
# Chạy trên cluster kind của bạn (trong WSL):
#     bash configmap-demo.sh            # có dừng để bạn đoán trước
#     NOPAUSE=1 bash configmap-demo.sh  # chạy thẳng, không dừng
#     bash configmap-demo.sh clean      # chỉ dọn namespace cm-demo
#
# Script dùng `kubectl`, KHÔNG dùng alias `k` (alias không có tác dụng
# trong script). Nếu muốn đổi: KUBECTL=/đường/dẫn/kubectl bash configmap-demo.sh
#
# Script tạo namespace `cm-demo`, ConfigMap `app-config` (GREETING=hello-v1)
# và pod `demo` đọc cùng một giá trị theo 3 cách:
#   1. ENV     : env var từ configMapKeyRef
#   2. VOLUME  : mount cả ConfigMap vào /etc/cfg-vol
#   3. SUBPATH : mount một key bằng subPath vào /etc/cfg-subpath/GREETING
# Sau đó sửa ConfigMap thành hello-v2 và so sánh 3 cách.
# =====================================================================
set -euo pipefail

K="${KUBECTL:-kubectl}"
NS=cm-demo
POD=demo

pause() {
  if [ "${NOPAUSE:-0}" != "1" ]; then
    read -r -p "$1 [Enter để tiếp tục] " _
  fi
}

say() { printf '\n\033[1m== %s ==\033[0m\n' "$1"; }

# In giá trị mà container đang thấy (chạy lệnh TRONG container).
show_values() {
  "$K" exec -n "$NS" "$POD" -- sh -c '
    echo "ENV     = $GREETING"
    echo "VOLUME  = $(cat /etc/cfg-vol/GREETING)"
    echo "SUBPATH = $(cat /etc/cfg-subpath/GREETING)"
  '
}

show_symlinks() {
  "$K" exec -n "$NS" "$POD" -- ls -la /etc/cfg-vol/
}

if [ "${1:-}" = "clean" ]; then
  "$K" delete namespace "$NS" --ignore-not-found
  exit 0
fi

say "0. Dọn lần chạy cũ (nếu có)"
"$K" delete namespace "$NS" --ignore-not-found --wait=true
"$K" create namespace "$NS"

say "1. Tạo ConfigMap (GREETING=hello-v1) và pod"
"$K" create configmap app-config -n "$NS" --from-literal=GREETING=hello-v1

apply_pod() {
  "$K" apply -n "$NS" -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: demo
spec:
  containers:
  - name: c
    image: busybox:1.36
    command: ["sleep", "3600"]
    env:
    - name: GREETING
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: GREETING
    volumeMounts:
    - name: cfg
      mountPath: /etc/cfg-vol
    - name: cfg
      mountPath: /etc/cfg-subpath/GREETING
      subPath: GREETING
  volumes:
  - name: cfg
    configMap:
      name: app-config
EOF
  "$K" wait -n "$NS" --for=condition=Ready "pod/$POD" --timeout=120s
}
apply_pod

say "2. TRƯỚC khi sửa: cả 3 cách đều phải là hello-v1"
show_values
echo
echo "Các file trong thư mục mount của VOLUME (để ý dấu -> là symlink):"
show_symlinks

echo
echo "Sắp sửa ConfigMap thành hello-v2."
echo "Hãy đoán: ENV, VOLUME, SUBPATH sẽ là v1 hay v2? Ghi ra giấy trước."
pause "Đã đoán xong?"

say "3. Sửa ConfigMap thành hello-v2"
"$K" patch configmap app-config -n "$NS" --type merge \
  -p '{"data":{"GREETING":"hello-v2"}}'

say "4. Đợi kubelet đồng bộ volume (tối đa 180 giây, kiểm tra mỗi 5 giây)"
start=$(date +%s)
changed=0
for _ in $(seq 1 36); do
  v=$("$K" exec -n "$NS" "$POD" -- cat /etc/cfg-vol/GREETING 2>/dev/null || true)
  if [ "$v" = "hello-v2" ]; then
    changed=1
    break
  fi
  printf '.'
  sleep 5
done
echo
elapsed=$(( $(date +%s) - start ))
if [ "$changed" = "1" ]; then
  echo "VOLUME đã thấy hello-v2 sau khoảng ${elapsed} giây."
else
  echo "Sau ${elapsed} giây VOLUME vẫn chưa đổi (bất thường, kiểm tra lại)."
fi

say "5. SAU khi sửa (pod vẫn là pod cũ, chưa restart)"
show_values
echo
echo "Thư mục mount của VOLUME: để ý symlink ..data đã trỏ sang thư mục mới:"
show_symlinks

say "6. Tạo lại pod: giờ ENV và SUBPATH mới nhận hello-v2"
"$K" delete pod "$POD" -n "$NS" --wait=true
apply_pod
show_values

cat <<'EOF'

== KẾT LUẬN CẦN NHỚ ==
- ENV     : chỉ đọc lúc container khởi động. Muốn giá trị mới phải tạo lại container.
- VOLUME  : kubelet cập nhật sau một khoảng ngắn (qua symlink ..data).
            Nhưng app vẫn phải tự đọc lại file.
- SUBPATH : bind mount vào file cụ thể, không đi qua ..data, nên KHÔNG cập nhật.

Dọn dẹp:  bash configmap-demo.sh clean
EOF
