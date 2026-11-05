---
tags:
  - k8s/networking
  - k8s/service
  - ckad
date: 2026-11-05
status: learning
aliases:
  - Service ClusterIP, Selector và Service CIDR
  - ClusterIP
  - Service CIDR
---

# Service ClusterIP, Selector và Service CIDR

↑ [[00 - Networking MOC]] · ← [[02 - Vi sao Pod can Service]] · → [[04 - Goi Service bang ten (DNS)]]

## Label và Selector

- Pod có label: `app=backend,pod-template-hash=74769dbc96`
- Deployment có selector: `app=backend`
- Service chọn Pod bằng **selector khớp với label**.

> [!tip] Ví von
> - **Label** = bảng tên trên áo nhân viên.
> - **Selector** = câu dặn tổng đài: "chỉ chuyển cho ai đeo bảng `app=backend`".

## Tạo Service ClusterIP

```bash
kubectl expose deployment backend --port=80
kubectl get svc -o wide
```

> [!example] Output thật
> ```text
> NAME      TYPE        CLUSTER-IP      PORT(S)   SELECTOR
> backend   ClusterIP   10.96.163.214   80/TCP    app=backend
> ```

Selector `app=backend` được lấy từ Deployment.

## Service CIDR khác Pod CIDR

Cấu hình control plane:

```text
--cluster-cidr=10.244.0.0/16             # Pod, chia /24 cho từng node
--service-cluster-ip-range=10.96.0.0/16  # riêng cho Service
```

- IP Service **không thuộc dải Pod**.
- Service không chạy trên node nào → IP **không gắn với node**. Node sập thì IP Service vẫn còn.

> [!warning] Từng hiểu nhầm
> Đoán IP Service cùng dải `10.244` với Pod. Sai: Service dùng dải `10.96.0.0/16`.

## Thí nghiệm 1: gọi Service từ Pod tạm

```bash
kubectl run tmp --rm -it --image=busybox --restart=Never -- wget -qO- 10.96.163.214
```

`--rm` = chạy xong tự xóa Pod.

> [!example] Output thật
> wget trả về HTML của nginx. Log nginx:
> ```text
> 10.244.1.8 ... "GET / HTTP/1.1" 200 896 "-" "Wget"
> ```

- `tmp` (`10.244.1.8`, ckad-worker) là **bên gửi**, wget chạy trong `tmp`.
- `backend` (`10.244.2.7`, ckad-worker2) là **bên nhận**.
- Request đi **xuyên node**.

```text
[tmp 10.244.1.8 @ckad-worker] → [Service 10.96.163.214] → [backend 10.244.2.7 @ckad-worker2]
```

## Thí nghiệm 2 (chốt): xóa Pod backend lần nữa

```bash
kubectl delete pod backend-74769dbc96-k7h6b
kubectl get pods -o wide
```

> [!example] Output thật
> ```text
> backend-74769dbc96-jxvw7  Running  10.244.1.9  ckad-worker
> ```
> Service `backend` vẫn là `10.96.163.214` (không đổi).
> wget lại → vẫn `200` (log từ `10.244.2.8` và `10.244.2.9`).

- Pod mới, IP mới, node mới.
- Service **vẫn** `10.96.163.214`.
- Thomas đoán đúng trước cả hai kết quả.

## So sánh

| Cách gọi | Pod bị xóa thì sao? | Phải sửa gì? |
| --- | --- | --- |
| Gọi thẳng IP Pod | Mất liên lạc | Phải sửa IP |
| Gọi qua Service | Vẫn `200` | Không cần sửa gì |

## Endpoints - danh bạ của Service

> [!question] Service biết IP mới của Pod bằng cách nào?
> Pod đổi IP mà không ai báo, vậy Service biết IP mới của Pod bằng cách nào? Ai cập nhật "danh bạ nhân viên" cho tổng đài?

### Danh bạ nằm ở đâu

```bash
kubectl describe svc backend
```

> [!example] Output thật (rút gọn)
> ```text
> Selector:    app=backend
> IP:          10.96.163.214
> TargetPort:  80/TCP
> Endpoints:   10.244.1.9:80
> ```
> Khớp với Pod `backend-74769dbc96-jxvw7  10.244.1.9  ckad-worker`.

- Dòng **`Endpoints`** = danh bạ: IP của Pod + port.
- Pod đổi IP từ `10.244.2.7` sang `10.244.1.9` mà mình **không hề sửa** dòng này, nên phải có ai đó tự động cập nhật.

### Thí nghiệm 3: scale lên 3 Pod

```bash
kubectl scale deployment backend --replicas=3
kubectl get pods -o wide -l app=backend
kubectl describe svc backend
```

> [!example] Output thật
> ```text
> backend-74769dbc96-4pr45   10.244.1.10   ckad-worker
> backend-74769dbc96-6qv68   10.244.2.10   ckad-worker2
> backend-74769dbc96-jxvw7   10.244.1.9    ckad-worker
> ```
> ```text
> Selector:   app=backend
> Endpoints:  10.244.1.9:80,10.244.1.10:80,10.244.2.10:80
> ```

- Danh bạ có **3 IP**, khớp đúng 3 Pod. Mình không đụng vào Service lần nào.
- Thomas đoán đúng trước: "3 IP do có thêm 2 Pod sinh ra".

### Ai cập nhật danh bạ?

```bash
kubectl get endpointslices -l kubernetes.io/service-name=backend --show-labels
kubectl -n kube-system get pods -l component=kube-controller-manager
```

> [!example] Output thật
> ```text
> NAME            ENDPOINTS                            LABELS
> backend-dfvwl   10.244.1.9,10.244.1.10,10.244.2.10   ...,endpointslice.kubernetes.io/managed-by=endpointslice-controller.k8s.io,
>                                                      kubernetes.io/service-name=backend
> ```
> ```text
> kube-controller-manager-ckad-control-plane   1/1   Running
> ```

- Label `managed-by` cho biết người cập nhật là **`endpointslice-controller`**, chạy trong `kube-controller-manager` ở control plane.
- Nó liên tục theo dõi các Pod có label khớp selector `app=backend`. Pod mới lên thì **thêm** IP, Pod chết thì **xóa** IP.

| "Người" | Theo dõi gì | Làm gì |
| --- | --- | --- |
| Deployment controller | Số lượng Pod | Thiếu thì tạo bù Pod |
| EndpointSlice controller | Pod khớp selector | Cập nhật danh bạ IP của Service |

> [!warning] Từng bí
> Lúc đầu không đoán được ai cập nhật danh bạ, phải dùng hết 2 mức gợi ý. **Không phải** Deployment làm việc này, mà là một controller khác.

> [!success] Câu trả lời của mình
> Pod đổi IP mà Service vẫn chuyển đúng là nhờ **EndpointSlice controller**. Nó dựa vào **Selector** để tìm những Pod có **Label** khớp, rồi cập nhật IP của chúng vào **Endpoints**.

## Có nên ghi cứng IP Service

> [!question] Có phải ghi cứng IP Service vào code không?
> Tới giờ toàn gọi Service bằng IP `10.96.163.214`. Trong code frontend thật, ghi cứng con số đó vào có ổn không? Còn cách nào khác để gọi tổng đài không?

### Thí nghiệm 4 - xóa và tạo lại Service

```bash
kubectl delete svc backend
kubectl expose deployment backend --port=80
kubectl get svc -o wide
kubectl describe svc backend
```

> [!example] Output thật
> ```text
> backend   ClusterIP   10.96.85.180   80/TCP   14s   app=backend
> ```
> ```text
> Endpoints:  10.244.1.9:80,10.244.2.10:80,10.244.1.10:80
> ```

| | Trước | Sau khi tạo lại |
| --- | --- | --- |
| NAME | `backend` | `backend` (giữ nguyên) |
| SELECTOR | `app=backend` | `app=backend` (giữ nguyên) |
| CLUSTER-IP | `10.96.163.214` | `10.96.85.180` (**đổi**) |
| Endpoints | 3 IP Pod | Tự cập nhật lại 3 IP Pod |

- Thomas đoán đúng trước: IP sẽ đổi.

> [!success] Câu trả lời của mình
> Ghi cứng IP không ổn, vì xóa và tạo lại Service thì IP đổi. Nên gọi bằng tên Service.
> → [[04 - Goi Service bang ten (DNS)]]
