---
tags:
  - k8s/networking
  - k8s/pod
  - ckad
date: 2026-11-05
status: learning
aliases:
  - Pod IP và PODCIDR
  - PODCIDR
---

# Pod IP và PODCIDR

↑ [[00 - Networking MOC]] · → [[02 - Vi sao Pod can Service]]

> [!note] Bối cảnh
> Cluster kind, context `kind-ckad`, namespace `exercise-03`.

## Tạo Pod và xem IP

```bash
kubectl create deployment backend --image=nginx
kubectl get pods -o wide
```

> [!example] Output thật
> ```text
> backend-74769dbc96-hqgwx  Running  10.244.1.6  ckad-worker
> ```

## PODCIDR của từng node

```bash
kubectl get nodes -o custom-columns=NAME:.metadata.name,INTERNAL-IP:.status.addresses[0].address,PODCIDR:.spec.podCIDR
```

> [!example] Output thật
> ```text
> NAME                 INTERNAL-IP   PODCIDR
> ckad-control-plane   172.18.0.4    10.244.0.0/24
> ckad-worker          172.18.0.2    10.244.1.0/24
> ckad-worker2         172.18.0.3    10.244.2.0/24
> ```

## Quy luật

- IP của Pod được cấp từ **PODCIDR của node** mà Pod đang chạy.
- Số thứ 3 trong IP khớp với node: `10.244.1.6` → `ckad-worker` (`10.244.1.0/24`).
- Mỗi node có một dải `/24` riêng để Pod ở các node khác nhau **không bị trùng IP**.

> [!tip] Tự tóm tắt (Thomas)
> "IP của POD lấy từ PODCIDR và mỗi node phải có 1 dải riêng bởi vì không muốn cho tình huống nhiều POD có cùng 1 IP."

> [!warning] Từng hiểu nhầm
> Lúc đầu đoán: Pod chuyển sang `ckad-worker2` thì **vẫn** có IP `10.244.1.x`.
> Sai. Pod ở `ckad-worker2` sẽ lấy IP từ `10.244.2.0/24`.
