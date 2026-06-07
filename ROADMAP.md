# Lộ Trình Ôn Thi CKAD + CKA — 14 Tuần

> Phuoc — Fresher DevOps/Cloud Engineer, HCMC
> Nguồn chính: **KodeKloud (Udemy)** | Lab thực hành: **LabEx.io**
> Thứ tự: CKAD trước → CKA sau

---

## Tổng quan

| | CKAD | CKA |
|---|---|---|
| Thời gian | Tuần 1–7 | Tuần 8–14 |
| Nguồn học | KodeKloud CKAD (Udemy) | KodeKloud CKA (Udemy) |
| LabEx main course | [ckad-prep](https://labex.io/courses/ckad-prep) — 42 labs | [cka-prep](https://labex.io/courses/cka-prep) — 48 labs |
| LabEx practice exam | [Practice Exam 01](https://labex.io/courses/ckad-practice-exam-01) + [02](https://labex.io/courses/ckad-practice-exam-02) — 40 challenges | [Practice Exam 01](https://labex.io/courses/cka-practice-exam-01) + [02](https://labex.io/courses/cka-practice-exam-02) — 40 challenges |
| Kết thúc | Thi CKAD tuần 7 | Thi CKA tuần 14 |

> **Cách dùng LabEx:** LabEx CKAD là 1 course duy nhất 42 labs chia 5 section theo thứ tự. Học song song KodeKloud xong, vào LabEx làm labs của section tương ứng cùng tuần đó.

---

## PHẦN 1 — CKAD (Tuần 1–7)

### Tuần 1 — Core Concepts

**KodeKloud:** Section "Core Concepts"
- [ ] Architecture tổng quan: API Server, etcd, Scheduler, Controller Manager
- [ ] Pods: tạo, xem, xóa (`kubectl run`, `kubectl get po`, `kubectl describe`)
- [ ] ReplicaSets: mục đích, selector, scale
- [ ] Deployments: tạo, scale, `kubectl rollout status`
- [ ] Namespaces: tạo, switch context, `-n` flag

**LabEx — Section "Kubernetes Application Foundations" (6 labs):**
- [ ] Explore kubectl, Contexts, and Namespaces
- [ ] Inspect Kubernetes API Resources
- [ ] Create and Inspect a Pod
- [ ] Write a Pod Manifest
- [ ] Use Labels and Selectors
- [ ] Generate and Edit Manifests with kubectl

**Report tuần này cần có:**
- Đã xem bao nhiêu % KodeKloud section
- Đã làm bao nhiêu lab LabEx (target: cả 6)
- Lệnh nào còn gõ sai / phải tra docs

---

### Tuần 2 — Configuration

**KodeKloud:** Section "Configuration" (39 lectures)
- [ ] Commands & Arguments trong Pod (CMD vs ENTRYPOINT)
- [ ] Environment Variables, ConfigMaps (literal, file, volume mount)
- [ ] Secrets (tạo, dùng trong Pod)
- [ ] SecurityContext (runAsUser, runAsNonRoot, capabilities)
- [ ] Resource Requests & Limits
- [ ] ServiceAccounts (tạo, mount vào Pod, RBAC cơ bản)
- [ ] Taints & Tolerations ← **có trong CKAD Configuration, không phải chỉ CKA**
- [ ] Node Selectors, Node Affinity ← **cũng trong CKAD Configuration section**

**LabEx — Section "Configuration, Storage, and Runtime Settings" (10 labs):**
- [ ] Configure Applications with ConfigMaps
- [ ] Configure Applications with Secrets
- [ ] Inject Environment Variables
- [ ] Mount Configuration Files
- [ ] Use Projected Volumes
- [ ] Set Resource Requests and Limits
- [ ] Apply Namespace Resource Quotas
- [ ] Run with a Dedicated ServiceAccount
- [ ] Harden a Pod Security Context
- [ ] Discover and Use Custom Resources

**Report tuần này cần có:**
- Phân biệt được `command` vs `args` trong YAML
- Tạo được ConfigMap và mount dưới dạng volume

---

### Tuần 3 — Multi-Container Pods & Pod Design

**KodeKloud:** Sections "Multi-Container Pods" + "Pod Design"
- [ ] Multi-container patterns: Sidecar, Init Container, Ambassador
- [ ] Labels, Selectors, Annotations
- [ ] Jobs: `completions`, `parallelism`, `backoffLimit`
- [ ] CronJobs: schedule syntax, `concurrencyPolicy`
- [ ] Rolling Updates & Rollbacks (`kubectl rollout undo`)
- [ ] Deployment strategies: Recreate vs RollingUpdate

**LabEx — Section "Workload Design and Build" (8 labs):**
- [ ] Create a Deployment
- [ ] Scale a Deployment
- [ ] Run One-Time Jobs
- [ ] Schedule CronJobs
- [ ] Choose the Right Workload Resource
- [ ] Add Init Containers
- [ ] Add a Sidecar Container
- [ ] Use Ephemeral and Persistent Volumes in Pods

**Report tuần này cần có:**
- Viết được Init Container YAML không cần tra docs
- Tạo được CronJob chạy mỗi 5 phút
- Biết cách rollback deployment về revision cụ thể

---

### Tuần 4 — Observability & Debugging

**KodeKloud:** Section "Observability"
- [ ] Liveness Probe (httpGet, tcpSocket, exec)
- [ ] Readiness Probe — khác gì Liveness
- [ ] Startup Probe
- [ ] Logging: `kubectl logs`, `kubectl logs -c <container>`
- [ ] Monitoring: `kubectl top pod/node` (Metrics Server)
- [ ] Debug Pod: `kubectl exec`, `kubectl describe`, Events section

**LabEx — Section "Observability, Debugging, and App Networking" (10 labs) — phần đầu:**
- [ ] Read Logs and Events
- [ ] Use exec and Port Forwarding for Debugging
- [ ] Configure Liveness and Readiness Probes
- [ ] Debug a CrashLooping Application
- [ ] Update Deprecated API Manifests

**Report tuần này cần có:**
- Giải thích được tại sao Pod Pending vs CrashLoopBackOff
- Debug được crashloop trong lab LabEx

---

### Tuần 5 — Services & Networking

**KodeKloud:** Section "Services & Networking"
- [ ] Service types: ClusterIP, NodePort, LoadBalancer, ExternalName
- [ ] Ingress: rules, paths, TLS, IngressClass
- [ ] NetworkPolicy: podSelector, policyTypes, ingress/egress rules
- [ ] DNS trong cluster: `<svc>.<ns>.svc.cluster.local`

**LabEx — Section "Observability, Debugging, and App Networking" (10 labs) — phần sau:**
- [ ] Expose a Deployment with a Service
- [ ] Diagnose Service DNS Access
- [ ] Route HTTP Traffic with Ingress
- [ ] Restrict Application Traffic with NetworkPolicy
- [ ] Repair Named Service Port Routing

**Report tuần này cần có:**
- Viết được NetworkPolicy chặn tất cả ingress trừ 1 namespace
- Tạo được Ingress route 2 path khác nhau

---

### Tuần 6 — State Persistence + Security + Helm

> ⚠️ Tuần nặng nhất: 3 KodeKloud sections (State Persistence 16 lectures + Security 29 lectures + Helm 7 lectures). Nếu không kịp, dời Security sang Tuần 7 trước khi thi.

**KodeKloud:** Sections "State Persistence" (16 lectures) + "Security" (29 lectures) + "Helm Fundamentals" (7 lectures)

**State Persistence:**
- [ ] Volumes: emptyDir, hostPath, configMap volume, secret volume
- [ ] PersistentVolume & PersistentVolumeClaim
- [ ] StorageClass & Dynamic Provisioning
- [ ] StatefulSets + headless service + volumeClaimTemplates ← **có trong CKAD State Persistence**

**Security (29 lectures — quan trọng cho CKAD 25%):**
- [ ] Authentication, KubeConfig
- [ ] API groups, authorization modes
- [ ] RBAC: Role, RoleBinding, ClusterRole, ClusterRoleBinding
- [ ] Admission Controllers (NamespaceLifecycle, NodeRestriction, MutatingAdmission...)
- [ ] Custom Resource Definitions (CRDs)
- [ ] API versioning & deprecation handling

**Helm Fundamentals:**
- [ ] Helm: `helm install/upgrade/rollback/uninstall`, `--values`, `--set`
- [ ] Kustomize: `kustomization.yaml`, bases, overlays, patches

**LabEx — Section "Deployment and Packaging" (8 labs):**
- [ ] Perform a Rolling Update
- [ ] Roll Back a Faulty Deployment
- [ ] Tune Deployment Update Strategy
- [ ] Implement a Canary Release
- [ ] Switch Blue-Green Traffic
- [ ] Deploy a Local Helm Chart
- [ ] Customize an Application with Kustomize
- [ ] Build and Run a Local Application Image

**Report tuần này cần có:**
- Tạo được PVC và mount vào Pod
- `helm install` được một chart với custom values
- Biết sự khác nhau giữa Canary và Blue-Green

---

### Tuần 7 — Review & Thi CKAD

**KodeKloud:** Lightning Labs + Mock Exam 1, 2, 3
- [ ] Lightning Lab 1 — ghi thời gian hoàn thành
- [ ] Lightning Lab 2
- [ ] Mock Exam 1 — note điểm, topic nào sai
- [ ] Mock Exam 2 — so sánh với Mock 1
- [ ] Mock Exam 3

**LabEx Practice Exams (40 challenges):**
- [ ] [CKAD Practice Exam 01](https://labex.io/courses/ckad-practice-exam-01) — 20 challenges theo 5 domain thực tế
- [ ] [CKAD Practice Exam 02](https://labex.io/courses/ckad-practice-exam-02) — 20 challenges scenarios khác

**Killer.sh:**
- [ ] Killer.sh CKAD session 1 (mua cùng voucher thi)
- [ ] Killer.sh CKAD session 2

**Report tuần này cần có:**
- Điểm từng mock exam KodeKloud
- Top 3 topic yếu nhất cần ôn lại

> **Thi CKAD** — đặt lịch thi cuối tuần 7

---

## PHẦN 2 — CKA (Tuần 8–14)

### Tuần 8 — Core Concepts + Scheduling

**KodeKloud:** Sections "Core Concepts" (44 lectures) + "Scheduling" (38 lectures)
- [ ] Cluster architecture sâu: etcd, kube-apiserver flags, kubelet config, container runtimes
- [ ] Pods, ReplicaSets, Deployments, Services (ôn lại từ CKA perspective)
- [ ] Manual Scheduling: nodeName field
- [ ] Taints & Tolerations
- [ ] Node Selectors, Node Affinity, Pod Affinity/Anti-Affinity
- [ ] Resource Requirements & LimitRange
- [ ] DaemonSets
- [ ] Static Pods (`/etc/kubernetes/manifests/`)
- [ ] Multiple Schedulers, Scheduler Profiles
- [ ] PodDisruptionBudgets (bảo vệ availability khi drain)

**LabEx — Section "Cluster Orientation and Admin Foundations" (7 labs):**
- [ ] Inspect kubeconfig and Contexts
- [ ] Explore Nodes and Cluster Version
- [ ] Inspect API Resources and Namespaces
- [ ] Read Events and Object Conditions
- [ ] Use Labels, Selectors, and Field Selectors
- [ ] Manage Namespaces for Administrative Workflows
- [ ] Use Dry Run and Explain for Manifests

**LabEx — Section "Workloads and Scheduling" (9 labs):**
- [ ] Inspect Deployment and ReplicaSet Behavior
- [ ] Perform a Controlled Deployment Rollout
- [ ] Roll Back a Broken Rollout
- [ ] Configure Workloads with ConfigMaps and Secrets
- [ ] Set Requests, Limits, and Resource Evidence
- [ ] Schedule Pods with Node Selectors
- [ ] Place Workloads with Affinity Rules
- [ ] Use Taints and Tolerations
- [ ] Protect Availability with PodDisruptionBudgets

**Report tuần này cần có:**
- Biết tìm Static Pod manifest ở đâu trên node
- Tạo được Pod với NodeAffinity required

---

### Tuần 9 — Logging, Monitoring & Application Lifecycle Management

> Section "Application Lifecycle Management" (35 lectures) bị thiếu trong phiên bản ROADMAP cũ — đây là section riêng trong KodeKloud CKA Udemy.

**KodeKloud:** Sections "Logging & Monitoring" (7 lectures) + "Application Lifecycle Management" (35 lectures)

**Logging & Monitoring:**
- [ ] Monitor cluster & nodes: Metrics Server, `kubectl top node/pod`
- [ ] Manage container logs: `kubectl logs`, `kubectl logs -c <container>`

**Application Lifecycle Management (35 lectures):**
- [ ] Rolling updates & rollbacks (ôn sâu từ admin perspective)
- [ ] Commands & Arguments trong container
- [ ] Environment variables, ConfigMaps, Secrets
- [ ] Init Containers (use cases thực tế)
- [ ] Self-healing, scale applications

**LabEx:** Các labs trong Section "Workloads and Scheduling" chưa làm từ Tuần 8

**Report tuần này cần có:**
- Giải thích cách CKA troubleshoot app failure qua logs + events
- Hoàn thành ít nhất 60% Application Lifecycle Management

---

### Tuần 10 — Cluster Maintenance & Security

**KodeKloud:** Sections "Cluster Maintenance" (13 lectures) + "Security" (45 lectures)
- [ ] OS Upgrades: drain, cordon, uncordon
- [ ] Cluster Upgrade với kubeadm: `kubeadm upgrade plan`, `apply`
- [ ] etcd backup: `etcdctl snapshot save` ← **có trong Practice Exam, cần luyện riêng**
- [ ] etcd restore: `etcdctl snapshot restore`
- [ ] TLS Certificates: CA, kube-apiserver cert, kubelet cert
- [ ] Certificate API: CertificateSigningRequest
- [ ] KubeConfig: clusters, users, contexts
- [ ] RBAC cluster-level (ClusterRole, ClusterRoleBinding)

**LabEx — Section "Cluster Architecture, Installation, and Configuration" (9 labs):**
- [ ] Inspect Control Plane Components
- [ ] Explore kubeadm Configuration Artifacts
- [ ] Inspect Certificates and Cluster Trust
- [ ] Grant Namespace Operator RBAC
- [ ] Delegate Read-Only Cluster Diagnostics
- [ ] Deploy an Addon with Helm
- [ ] Customize Cluster Resources with Kustomize
- [ ] Define and Use a Custom Resource
- [ ] Inspect CNI, CSI, and CRI Interfaces

> **Lưu ý:** etcd backup/restore không có lab trong `cka-prep` — chỉ có trong Practice Exam 01. Luyện command riêng qua KodeKloud.

**Report tuần này cần có:**
- Chạy được etcd backup & restore thành công
- `kubeadm upgrade apply` trên cluster test

---

### Tuần 11 — Networking (CKA)

**KodeKloud:** Section "Networking" (37 lectures)
- [ ] Network fundamentals: switching, routing, DNS
- [ ] CNI plugins: Calico, Flannel (biết cài đặt)
- [ ] Pod networking model
- [ ] Service Networking & kube-proxy modes
- [ ] CoreDNS: config, debug `nslookup`, conditional forwarding
- [ ] EndpointSlice (topic mới — thay thế Endpoints)
- [ ] Ingress (ôn lại, thêm IngressClass)
- [ ] Gateway API: HTTPRoute, GatewayClass (topic mới 2026)

**LabEx — Section "Services and Networking" (8 labs):**
- [ ] Expose Applications with Services
- [ ] Repair EndpointSlice Service Access
- [ ] Troubleshoot Service DNS Resolution
- [ ] Configure CoreDNS Conditional Forwarding
- [ ] Restrict Egress with NetworkPolicy
- [ ] Repair NetworkPolicy Access
- [ ] Route HTTP Traffic with Ingress
- [ ] Publish an API with Gateway Routing ← **Gateway API thực tế**

**Report tuần này cần có:**
- Debug được pod không resolve được DNS
- Làm được lab Gateway API trên LabEx

---

### Tuần 12 — Storage

**KodeKloud:** Section "Storage" (16 lectures)
- [ ] PersistentVolume, PersistentVolumeClaim chi tiết
- [ ] StorageClass & Dynamic Provisioning
- [ ] Volume access modes: ReadWriteOnce, ReadOnlyMany, ReadWriteMany
- [ ] Reclaim policies: Retain, Delete, Recycle
- [ ] StatefulSets: headless service, volumeClaimTemplates
- [ ] Troubleshoot PVC: Pending, mismatched accessMode/storageClass

**LabEx — Section "Storage" (6 labs):**
- [ ] Inspect StorageClasses and Dynamic Provisioning
- [ ] Create a PVC for Application Data
- [ ] Bind a Static PersistentVolume
- [ ] Configure Access Modes and Volume Modes
- [ ] Preserve Data with Reclaim Policies
- [ ] Troubleshoot PVC Binding and Mounts

**Report tuần này cần có:**
- Tạo được PVC dynamic binding thành công
- Debug được PVC stuck ở Pending

---

### Tuần 13 — Troubleshooting + Install Kubernetes (trọng tâm nhất CKA — 30%)

**KodeKloud:** Sections "Troubleshooting" + "Design and Install a Kubernetes Cluster" (5 lectures)
- [ ] Application Failure: Pod status, logs, events
- [ ] Control Plane Failure: kiểm tra kube-apiserver, scheduler, controller-manager
- [ ] Worker Node Failure: kubelet status, node conditions
- [ ] Network Troubleshooting: kube-proxy, CoreDNS, CNI
- [ ] JSON Path: lọc output kubectl (`-o jsonpath`)
- [ ] Custom Columns: `kubectl get pods -o custom-columns`

**LabEx — Section "Troubleshooting and Maintenance" (9 labs):**
- [ ] Diagnose Cluster Resource Pressure
- [ ] Monitor Pods with Metrics and Top
- [ ] Manage Container Output Streams
- [ ] Debug Image Pull Failures
- [ ] Diagnose Failed Init Containers
- [ ] Restore a Crashing Static Pod Manifest
- [ ] Safely Drain and Restore a Node
- [ ] Recover Metrics-Based Scaling Signals
- [ ] Restore Broken Service Traffic

**Install Kubernetes:**
- [ ] kubeadm init: `--pod-network-cidr`, `--apiserver-advertise-address`
- [ ] Join worker node: `kubeadm join`
- [ ] Cài CNI plugin sau khi init
- [ ] HA cluster: stacked etcd vs external etcd (conceptual)

**Report tuần này cần có:**
- Debug được cluster với kube-apiserver down
- Viết được JSONPath query lấy image của tất cả containers
- Setup được 1 node cluster với kubeadm

---

### Tuần 14 — Review & Thi CKA

**KodeKloud:** Lightning Labs (CKA) + Mock Exam 1, 2, 3
- [ ] Lightning Lab 1
- [ ] Lightning Lab 2
- [ ] Mock Exam 1 — ghi điểm
- [ ] Mock Exam 2
- [ ] Mock Exam 3

**LabEx Practice Exams (40 challenges):**
- [ ] [CKA Practice Exam 01](https://labex.io/courses/cka-practice-exam-01) — 20 challenges
- [ ] [CKA Practice Exam 02](https://labex.io/courses/cka-practice-exam-02) — 20 challenges

**Killer.sh:**
- [ ] Killer.sh CKA session 1
- [ ] Killer.sh CKA session 2
- [ ] Ôn lại top 3 topic yếu từ mock exams

> **Thi CKA** — đặt lịch thi cuối tuần 14

---

## Kỹ thuật thi (thiết lập ngay khi vào phòng thi)

```bash
# Alias bắt buộc
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period 0"

# Dùng:
k run nginx --image=nginx $do > pod.yaml
k delete pod nginx $now
```

```bash
# Imperative commands thường dùng
k run nginx --image=nginx
k create deployment web --image=nginx --replicas=3
k expose pod nginx --port=80 --target-port=8080
k create configmap app-config --from-literal=ENV=prod
k create secret generic app-secret --from-literal=PASS=abc123
k create serviceaccount my-sa
k create role reader --verb=get,list --resource=pods
k create rolebinding rb1 --role=reader --serviceaccount=default:my-sa
k create clusterrole cluster-reader --verb=get,list --resource=pods
k create clusterrolebinding crb1 --clusterrole=cluster-reader --user=jane
```

**Bookmark được phép dùng trong phòng thi:**
- kubernetes.io/docs
- kubernetes.io/blog
- helm.sh/docs

---

## Topics mới 2026 — không bỏ qua

| Topic | Tuần ôn | Exam | LabEx Lab |
|---|---|---|---|
| Helm | Tuần 6 + 9 | CKAD + CKA | Deploy a Local Helm Chart / Deploy an Addon with Helm |
| Kustomize | Tuần 6 + 9 | CKAD + CKA | Customize an App with Kustomize / Customize Cluster Resources |
| Gateway API | Tuần 10 | CKA | Publish an API with Gateway Routing |
| CRDs & Custom Resources | Tuần 2 + 9 | CKAD + CKA | Discover and Use Custom Resources / Define and Use a Custom Resource |
| Dynamic Storage Provisioning | Tuần 11 | CKA | Inspect StorageClasses and Dynamic Provisioning |
| PodDisruptionBudgets | Tuần 8 | CKA | Protect Availability with PodDisruptionBudgets |
| EndpointSlice | Tuần 10 | CKA | Repair EndpointSlice Service Access |

---

## Tiến độ

| Mốc | KodeKloud Section | Trạng thái | Ngày xong |
|---|---|---|---|
| Tuần 1 — Core Concepts | Core Concepts (34 lectures) | [ ] | |
| Tuần 2 — Configuration | Configuration (39 lectures) | [ ] | |
| Tuần 3 — Multi-Container + Pod Design | Multi-Container Pods + Pod Design | [ ] | |
| Tuần 4 — Observability | Observability (10 lectures) | [ ] | |
| Tuần 5 — Services & Networking | Services & Networking (11 lectures) | [ ] | |
| Tuần 6 — State Persistence + Security + Helm | State Persistence + Security + Helm (52 lectures) | [ ] | |
| Tuần 7 — CKAD Practice Exams + **Thi CKAD** | Lightning Labs + Mock Exams | [ ] | |
| Tuần 8 — Core Concepts + Scheduling | Core Concepts + Scheduling (82 lectures) | [ ] | |
| Tuần 9 — Logging + App Lifecycle | Logging & Monitoring + App Lifecycle (42 lectures) | [ ] | |
| Tuần 10 — Cluster Maintenance + Security | Cluster Maintenance + Security (58 lectures) | [ ] | |
| Tuần 11 — Networking CKA | Networking (37 lectures) | [ ] | |
| Tuần 12 — Storage CKA | Storage (16 lectures) | [ ] | |
| Tuần 13 — Troubleshooting + Install K8s | Troubleshooting + Design/Install (30% exam weight) | [ ] | |
| Tuần 14 — CKA Practice Exams + **Thi CKA** | Lightning Labs + Mock Exams | [ ] | |

---

*Nguồn: [CNCF Curriculum](https://github.com/cncf/curriculum) | [LabEx CKAD Path](https://labex.io/learn/ckad) | [LabEx CKA Path](https://labex.io/learn/cka)*
