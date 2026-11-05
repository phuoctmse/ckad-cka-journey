# =====================================================================
# ckad-aliases.sh  -  bộ alias riêng của Thomas cho CKAD / CKA
# =====================================================================
# MỤC TIÊU: cả khối MINI (bên dưới) gõ tay xong dưới 2 phút. Giữ nó ngắn.
#
# ---------------------------------------------------------------------
# 1) CÀI Ở NHÀ (WSL2 + kind)
# ---------------------------------------------------------------------
#   cp ckad-aliases.sh ~/ckad-aliases.sh
#   echo 'source ~/ckad-aliases.sh' >> ~/.bashrc
#   source ~/.bashrc
# Kiểm tra: `alias` phải liệt kê k, kns, kgp, kgd, kgs, kd, kl và `echo $do`
# phải in ra --dry-run=client -o yaml.
#
# ---------------------------------------------------------------------
# 2) CÁCH LÀM TRONG PHÒNG THI
# ---------------------------------------------------------------------
# a. ĐẦU GIỜ (một lần, tính vào 2 giờ thi): gõ tay khối MINI vào notepad /
#    VSCode của môi trường thi để có chỗ copy. Không mang file này vào được
#    và không dựa vào clipboard từ máy ngoài (chưa có tài liệu nào cho phép;
#    hỏi proctor lúc check-in nếu muốn chắc).
# b. MỖI CÂU: đọc đề (ghi host + namespace) -> `ssh <host>` -> dán khối MINI
#    vào terminal bằng Ctrl+Shift+V -> `kns <namespace>` -> làm câu.
#    Xong câu: `exit` về node base. Sang host khác thì dán lại.
#    Mục tiêu: chuỗi ssh -> dán -> kns dưới 15 giây.
# c. Node `base` KHÔNG có kubectl. Chỉ dán sau khi đã ssh sang host của câu.
# d. Host thi đã có sẵn alias k và bash completion của kubectl (theo trang
#    Important Instructions của Linux Foundation). Alias tự đặt (kd, kl, kgp,
#    ...) thì KHÔNG tự có completion tên resource. Cần Tab thì gõ `k describe`
#    / `k get` đầy đủ.
# e. Muốn dán YAML vào vim: gõ `:set paste` trước, `:set nopaste` sau.
#    Khối MINI KHÔNG đụng ~/.vimrc. Ở câu đầu có sửa YAML, kiểm tra vim:
#    mở file, nhấn Tab, `:set list`. Thấy ^I (tab thật) thì gõ
#    `:set et ts=2 sw=2` trước khi gõ tiếp (YAML cấm tab).
#
# ---------------------------------------------------------------------
# 3) CÁCH CHỌN VÀ SỬA ALIAS
# ---------------------------------------------------------------------
# - Đếm lệnh gõ nhiều nhất (chạy sau vài buổi lab, lặp lại ở tuần 2 và 3):
#     history -a
#     history | sed 's/^ *[0-9]* *//' | awk '{print $1,$2,$3}' | sort | uniq -c | sort -rn | head -25
# - Chỉ giữ alias cho lệnh thật sự gõ nhiều. Hơn khoảng 8-10 dòng là vượt
#   ngân sách 2 phút.
# - $do và $now là BIẾN (export), vì phải đứng cuối lệnh. Alias chỉ thay
#   từ đầu dòng nên không làm được việc đó.
# - Viết alias bằng `k` (không dùng `kubectl`): ngắn hơn, mà alias được mở
#   rộng đệ quy ở từ đầu tiên nên vẫn chạy đúng.
# - Bấm giờ gõ cả khối. Chưa dưới 2 phút thì cắt bớt alias.
# - Thử `shopt -s progcomp_alias` nếu muốn alias có Tab completion (bash >= 5).
#   Mình chưa kiểm chứng bash của host thi có hỗ trợ không, nên không thêm
#   vào MINI.
# =====================================================================


# ---------------------- MINI (gõ / dán phần này) ---------------------
alias k=kubectl
export do="--dry-run=client -o yaml"
alias kns='k config set-context --current --namespace'
alias kgp='k get po'
alias kgd='k get deploy'
alias kgs='k get svc'
alias kd='k describe'
alias kl='k logs'
# ---------------------------------------------------------------------
# Ghi chú cho khối trên:
# - $do : k run web --image=nginx $do > pod.yaml
# - kns : đổi namespace mặc định cho host HIỆN TẠI. Luôn kiểm tra namespace
#         của từng câu; nhiều câu không nằm ở `default`.


# ---------------------- TUỲ CHỌN (chưa nằm trong MINI) ---------------
# Gộp ba alias get thành một, phủ cả ingress, pv, netpol:
#   alias kg='k get'
# Xoá pod nhanh khi đề cho phép (đừng dùng với StatefulSet hay pod do
# Deployment quản lý). Đặt cuối lệnh: k delete pod web $now
#   export now="--force --grace-period=0"
# Ép vim thụt lề bằng dấu cách (YAML cấm tab). Bỏ khỏi MINI vì mình thạo
# vim; có thể gõ tay :set et ts=2 sw=2 khi cần. Lưu ý: tạo ~/.vimrc có thể
# làm vim bỏ qua cấu hình mặc định của nó trên một số máy, chưa kiểm chứng
# với host thi.
#   printf 'set et ts=2 sw=2 ai\n' > ~/.vimrc
# Chỉ cần nếu không thạo vim (k edit mặc định mở vim):
#   export KUBE_EDITOR=nano
# =====================================================================