---
tags:
  - k8s/networking
  - k8s/service
  - ckad
date: 2026-11-05
status: learning
aliases:
  - Vì sao Pod cần Service
---

# Vì sao Pod cần Service

↑ [[00 - Networking MOC]] · ← [[01 - Pod IP va PODCIDR]] · → [[03 - Service ClusterIP, Selector va Service CIDR]]

## Xóa Pod, quan sát Pod mới

```bash
kubectl delete pod backend-74769dbc96-hqgwx
kubectl get pods -o wide
```

> [!example] Output thật
> ```text
> # Trước
> backend-74769dbc96-hqgwx  Running  10.244.1.6  ckad-worker
> # Sau
> backend-74769dbc96-k7h6b  Running  10.244.2.7  ckad-worker2
> ```

Pod mới có **tên mới**, **IP mới**, và có thể nằm ở **node khác** (IP theo PODCIDR của node mới, xem [[01 - Pod IP va PODCIDR]]).

## Hệ quả

- Frontend gọi thẳng IP Pod cũ `10.244.1.6` → **mất liên lạc**, vì không còn ai giữ IP đó.
- Deployment **không có IP**: trong YAML không có trường `ip` / `address` / `port` nào. Deployment chỉ là "người quản lý", đảm bảo đủ số Pod.

## Ví von

| Thành phần | Vai trò |
| --- | --- |
| Pod | Nhân viên |
| Deployment | Phòng nhân sự (tuyển lại nhân viên khi có người nghỉ) |
| Service | Tổng đài có số cố định, nhận cuộc gọi rồi chuyển tới nhân viên |

> [!tip] Tự kết luận (Thomas)
> - Deployment lo **tạo lại Pod**.
> - Service giữ **IP cố định**.
> - Frontend gọi vào **Service**, không gọi thẳng vào Pod.
>
> "IP của Pod không đáng tin vì mỗi lần Pod bị xóa thì IP cũng bị xóa đi."

> [!warning] Từng hiểu nhầm
> - Tưởng IP cố định đặt trên **Pod** hoặc trên **Deployment**. Sai: IP cố định thuộc về **Service**.
> - Tưởng "Service tạo Pod với IP cố định". Sai: **Deployment** mới là bên tạo Pod.
