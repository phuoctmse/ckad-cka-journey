---
tags:
  - k8s/networking
  - k8s/service
  - k8s/dns
  - ckad
date: 2026-11-05
status: learning
aliases:
  - Gọi Service bằng tên (DNS)
  - CoreDNS
  - Service DNS
---

# Gọi Service bằng tên (DNS)

↑ [[00 - Networking MOC]] · ← [[03 - Service ClusterIP, Selector va Service CIDR]]

## Gọi bằng tên

```bash
kubectl run tmp --rm -it --image=busybox --restart=Never -- wget -qO- backend
```

> [!example] Output thật
> wget trả về trang **"Welcome to nginx!"**.

- Không cần IP, chỉ cần tên Service `backend`.
- Thomas đoán đúng trước.

> [!tip] Ví von
> - **Selector** = việc bên trong tổng đài: chọn nhân viên nào nhận cuộc gọi.
> - **Name** = tên trong danh bạ điện thoại ("Tổng đài Backend").
> - Nên frontend gọi bằng **Name**.

## Ai đổi tên thành IP - DNS của cluster

Thomas tự đoán ra là **DNS**, giống `google.com` ngoài đời.

```bash
kubectl -n kube-system get svc kube-dns
kubectl -n kube-system get pods -l k8s-app=kube-dns -o wide
```

> [!example] Output thật
> ```text
> kube-system   kube-dns   ClusterIP   10.96.0.10   53/UDP,53/TCP,9153/TCP
> ```
> ```text
> coredns-559f6c778d-c6f8g   10.244.0.3   ckad-control-plane
> coredns-559f6c778d-zjxvq   10.244.0.2   ckad-control-plane
> ```

- DNS của cluster là **CoreDNS**. Nó chạy dưới dạng **Pod** và được gọi qua **Service `kube-dns`**.
- Port `53` là port chuẩn của DNS.
- Lại đúng mô hình tổng đài: Service `kube-dns` là IP cố định, Pod `coredns` là nhân viên.

| Thành phần | Loại | IP |
| --- | --- | --- |
| `kube-dns` | Service (tổng đài) | `10.96.0.10` |
| `coredns-...` | Pod (nhân viên) | `10.244.0.2`, `10.244.0.3` |

## Hỏi thẳng DNS bằng nslookup

```bash
kubectl run tmp --rm -it --image=busybox --restart=Never -- nslookup backend
```

> [!example] Output thật (rút gọn, bỏ các dòng NXDOMAIN)
> ```text
> Server:   10.96.0.10
> Address:  10.96.0.10:53
> Name:     backend.exercise-03.svc.cluster.local
> Address:  10.96.85.180
> ```

- Người trả lời là `10.96.0.10`, tức Service `kube-dns`.
- Thomas đoán đúng: DNS trả về IP của **Service** (`10.96.85.180`), không phải IP của Pod, "vì backend là tên Service".

## Tên đầy đủ (FQDN)

`backend.exercise-03.svc.cluster.local`

| Phần | Ý nghĩa |
| --- | --- |
| `backend` | Tên Service |
| `exercise-03` | Namespace |
| `svc` | service (cùng chữ viết tắt trong `kubectl get svc`) |
| `cluster.local` | Tên miền của cluster, giống `.com` ngoài đời |

Dạng chung: `<service>.<namespace>.svc.cluster.local`

```bash
kubectl -n kube-system get cm kubelet-config -o yaml
```

> [!example] Output thật (bằng chứng từ config kubelet)
> ```yaml
> clusterDNS:
> - 10.96.0.10
> clusterDomain: cluster.local
> ```

## Pod biết hỏi DNS ở đâu - /etc/resolv.conf

```bash
kubectl exec deploy/backend -- cat /etc/resolv.conf
```

> [!example] Output thật
> ```text
> search exercise-03.svc.cluster.local svc.cluster.local cluster.local
> nameserver 10.96.0.10
> options ndots:5
> ```

- Lúc tạo Pod, **kubelet** lấy `clusterDNS` trong config của nó rồi ghi thành dòng `nameserver` trong file này.
- Nhờ vậy Pod nào vừa sinh ra cũng đã biết phải hỏi DNS ở đâu.
- Thomas đoán đúng cả "IP của kube-dns" lẫn "kubelet ghi".

> [!tip] Git Bash trên Windows
> Phải đặt `MSYS_NO_PATHCONV=1` trước lệnh, nếu không đường dẫn `/etc/resolv.conf` sẽ bị đổi thành `C:/Program Files/Git/etc/resolv.conf`.
> ```bash
> MSYS_NO_PATHCONV=1 kubectl exec deploy/backend -- cat /etc/resolv.conf
> ```

## Sơ đồ đường đi

```text
tmp ──"backend là ai?"──▶ kube-dns (10.96.0.10) ──▶ "10.96.85.180"
tmp ──wget 10.96.85.180──▶ Service backend ──▶ một Pod nginx
```

> [!warning] Từng hiểu nhầm
> - Nghĩ `10.96.0.10` là "IP của cluster". Sai: đó là IP của **Service kube-dns**.
> - Nghĩ đó là IP của "Pod kube-dns". Sai: kube-dns là **Service**, còn Pod là `coredns` (`10.244.0.x`).
> - Nghĩ kubelet dùng `clusterDNS` "để chuyển traffic đến Pod". Sai: kubelet chỉ **ghi IP DNS** vào `/etc/resolv.conf` lúc tạo Pod, không chuyển traffic.
> - Lúc đầu cho rằng lý do chính để gọi bằng tên là "dễ nhớ". Lý do quan trọng hơn: IP của Service **đổi** khi xóa và tạo lại, còn tên thì giữ nguyên.

> [!success] Câu trả lời của mình
> Nên gọi Service bằng tên vì IP của Service có thể đổi khi xóa và tạo lại Service, còn tên thì giữ nguyên (tên cũng dễ nhớ hơn). Pod hỏi Service kube-dns (`10.96.0.10`, được kubelet ghi sẵn vào `/etc/resolv.conf`) để đổi tên thành IP.

## Câu hỏi còn bỏ ngỏ

> [!question] Vì sao nslookup in ra NXDOMAIN?
> Vì sao `nslookup backend` in ra mấy dòng `NXDOMAIN` (`backend.cluster.local`, `backend.svc.cluster.local`) trước khi tìm ra tên đúng, rồi Pod kết thúc với `(Error)`?
> Gợi ý: nhìn dòng `search` trong `/etc/resolv.conf`.
>
> **Câu trả lời của mình:**
>
