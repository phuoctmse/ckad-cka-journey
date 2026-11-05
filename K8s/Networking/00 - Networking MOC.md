---
tags:
  - k8s/networking
  - ckad
  - moc
date: 2026-11-05
status: learning
aliases:
  - Networking MOC
  - Mục lục Networking
---

# Networking MOC

> [!note] Bối cảnh
> Ôn CKAD (thi 12/12/2026). Cluster kind, context `kind-ckad`, namespace `exercise-03`.
> Học kiểu Socratic: tự đoán trước, kiểm chứng trên cluster sau.

## Lộ trình

Pod → Service → NodePort → LoadBalancer → Ingress

| Stage | Note | Trạng thái |
| --- | --- | --- |
| Pod | [[01 - Pod IP va PODCIDR]] | Đang học |
| Pod → Service | [[02 - Vi sao Pod can Service]] | Đang học |
| Service (ClusterIP) | [[03 - Service ClusterIP, Selector va Service CIDR]] | Đang học |
| Service DNS | [[04 - Goi Service bang ten (DNS)]] | Đang học |
| NodePort | — | Chưa học |
| LoadBalancer | — | Chưa học |
| Ingress | — | Chưa học |

## Ý chính cần nhớ

- IP của Pod lấy từ PODCIDR của node đang chạy Pod; mỗi node một dải `/24` riêng. → [[01 - Pod IP va PODCIDR]]
- Pod bị xóa thì tên, IP, node đều có thể đổi; Deployment tạo lại Pod nhưng không có IP. → [[02 - Vi sao Pod can Service]]
- Service giữ IP cố định (dải `10.96.0.0/16`, tách khỏi dải Pod `10.244.0.0/16`), chọn Pod bằng selector khớp label. → [[03 - Service ClusterIP, Selector va Service CIDR]]
- `Endpoints` là danh bạ IP Pod của Service. **EndpointSlice controller** (trong `kube-controller-manager`) tự cập nhật danh bạ theo các Pod khớp selector. → [[03 - Service ClusterIP, Selector va Service CIDR#Endpoints - danh bạ của Service]]
- Gọi Service bằng **tên** vì IP Service đổi khi tạo lại. **CoreDNS** (Service `kube-dns` `10.96.0.10`) đổi tên thành IP; FQDN có dạng `<service>.<namespace>.svc.cluster.local`; kubelet ghi IP DNS vào `/etc/resolv.conf` của Pod. → [[04 - Goi Service bang ten (DNS)]]

## Câu hỏi đã trả lời

> [!success] Service biết IP mới của Pod bằng cách nào?
> Pod đổi IP mà Service vẫn chuyển đúng là nhờ **EndpointSlice controller**. Nó dựa vào **Selector** để tìm những Pod có **Label** khớp, rồi cập nhật IP của chúng vào **Endpoints**.

> [!success] Có phải ghi cứng IP Service vào code không?
> Ghi cứng IP không ổn, vì xóa và tạo lại Service thì IP đổi. Nên gọi bằng tên Service.
> Xem [[03 - Service ClusterIP, Selector va Service CIDR#Có nên ghi cứng IP Service]] và [[04 - Goi Service bang ten (DNS)]].

## Câu hỏi còn bỏ ngỏ

> [!question] Vì sao nslookup in ra NXDOMAIN?
> Vì sao `nslookup backend` in ra mấy dòng `NXDOMAIN` (`backend.cluster.local`, `backend.svc.cluster.local`) trước khi tìm ra tên đúng, rồi Pod kết thúc với `(Error)`?
> Gợi ý: nhìn dòng `search` trong `/etc/resolv.conf`.
> Xem [[04 - Goi Service bang ten (DNS)#Câu hỏi còn bỏ ngỏ]].
>
> **Câu trả lời của mình:**
>

## Lệnh hay dùng

```bash
# Tạo Deployment
kubectl create deployment backend --image=nginx

# Xem PODCIDR của từng node
kubectl get nodes -o custom-columns=NAME:.metadata.name,INTERNAL-IP:.status.addresses[0].address,PODCIDR:.spec.podCIDR

# Xóa Pod (Deployment sẽ tạo Pod mới)
kubectl delete pod backend-74769dbc96-hqgwx

# Tạo Service ClusterIP cho Deployment
kubectl expose deployment backend --port=80

# Gọi Service từ Pod tạm, chạy xong tự xóa (--rm)
kubectl run tmp --rm -it --image=busybox --restart=Never -- wget -qO- 10.96.163.214

# Xem danh bạ (Endpoints) của Service
kubectl describe svc backend

# Scale Deployment
kubectl scale deployment backend --replicas=3

# Xem Pod theo label
kubectl get pods -o wide -l app=backend

# Xem EndpointSlice của Service (label managed-by cho biết ai quản lý)
kubectl get endpointslices -l kubernetes.io/service-name=backend --show-labels

# Xóa Service (tạo lại bằng expose thì IP Service đổi)
kubectl delete svc backend

# Gọi Service bằng tên từ Pod tạm
kubectl run tmp --rm -it --image=busybox --restart=Never -- wget -qO- backend

# Hỏi DNS tên Service từ Pod tạm
kubectl run tmp --rm -it --image=busybox --restart=Never -- nslookup backend

# Xem Service DNS của cluster
kubectl -n kube-system get svc kube-dns

# Xem Pod CoreDNS
kubectl -n kube-system get pods -l k8s-app=kube-dns -o wide

# Xem Pod hỏi DNS ở đâu (Git Bash: thêm MSYS_NO_PATHCONV=1 ở đầu)
kubectl exec deploy/backend -- cat /etc/resolv.conf
```
