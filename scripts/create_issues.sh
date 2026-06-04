#!/bin/bash

# Kiểm tra xem đã cài đặt GitHub CLI (`gh`) chưa
if ! command -v gh &> /dev/null; then
    echo "❌ Không tìm thấy GitHub CLI (gh). Vui lòng cài đặt từ https://cli.github.com/"
    exit 1
fi

# Kiểm tra trạng thái đăng nhập
if ! gh auth status &> /dev/null; then
    echo "❌ Bạn chưa đăng nhập GitHub CLI. Vui lòng chạy lệnh: gh auth login"
    exit 1
fi

echo "🚀 Bắt đầu khởi tạo dữ liệu cho repo..."

# 1. Tạo Labels
echo "🏷️ Đang tạo Labels..."
LABELS=(
    "phase-0:#5319e7"
    "ckad:#0052cc"
    "cka:#d93f0b"
    "udemy:#fbca04"
    "labex:#0e8a16"
    "drill:#b60205"
    "mock-exam:#1d76db"
    "new-2026:#d4c5f9"
)
for label in "${LABELS[@]}"; do
    NAME="${label%%:*}"
    COLOR="${label##*:}"
    gh label create "$NAME" --color "$COLOR" --force &>/dev/null || echo "Label '$NAME' đã tồn tại."
done

# 2. Tạo Milestones
echo "⛰️ Đang tạo Milestones..."
gh api -X POST repos/{owner}/{repo}/milestones -f title="CKAD" &>/dev/null || echo "Milestone CKAD có thể đã tồn tại."
gh api -X POST repos/{owner}/{repo}/milestones -f title="CKA" &>/dev/null || echo "Milestone CKA có thể đã tồn tại."

# 3. Import Issues
echo "📝 Đang tạo 37 Issues..."

# Hàm tiện ích để tạo Issue
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local milestone="$4"
    
    local milestone_flag=""
    if [ -n "$milestone" ]; then
        milestone_flag="--milestone $milestone"
    fi

    gh issue create \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        $milestone_flag > /dev/null
    
    echo "✅ Đã tạo: $title"
}

# --- PHASE 0 ---
create_issue "[PHASE 0][W1] Docker Mastery — Section 1–6" "Nguồn: Udemy (Bret Fisher)\nNội dung: Images, containers, volumes, networks, Docker Compose" "phase-0,udemy" ""
create_issue "[PHASE 0][W1] LabEx: Docker for Beginners Skill Tree" "Nguồn: labex.io\nNội dung: Hoàn thành 10–12 labs đầu tiên" "phase-0,labex" ""
create_issue "[PHASE 0][W2] Docker Mastery — Kubernetes intro" "Nguồn: Udemy (Bret Fisher)\nNội dung: Pods, Deployments, Services, kubectl cơ bản" "phase-0,udemy" ""
create_issue "[PHASE 0][W2] LabEx: Kubernetes for Beginners Skill Tree" "Nguồn: labex.io\nNội dung: Pod, Service, Deployment hands-on" "phase-0,labex" ""
create_issue "[PHASE 0][W2] Setup môi trường local: kind hoặc minikube" "Nội dung: Cài kind hoặc minikube để practice offline" "phase-0,drill" ""

# --- PHASE 1 (CKAD) ---
create_issue "[PHASE 1][W3] KodeKloud CKAD — Module 1–3: Core Concepts" "Nguồn: Udemy KodeKloud\nNội dung: Core Concepts, ConfigMap/Secret/ResourceLimits, Multi-container Pods" "ckad,udemy" "CKAD"
create_issue "[PHASE 1][W3] LabEx: Running Containers in Kubernetes" "Nguồn: labex.io\nNội dung: Pod patterns, init containers, env injection" "ckad,labex" "CKAD"
create_issue "[PHASE 1][W4] KodeKloud CKAD — Module 4–5: Observability & Pod Design" "Nguồn: Udemy KodeKloud\nNội dung: Liveness/Readiness Probes, Logging; Labels, Rollouts, Strategies" "ckad,udemy" "CKAD"
create_issue "[PHASE 1][W4] LabEx: Deployment & Rolling Update labs" "Nguồn: labex.io\nNội dung: kubectl rollout, canary, blue-green" "ckad,labex" "CKAD"
create_issue "[PHASE 1][W4] Kubectl speed drill — imperative commands" "Nội dung: create/expose/run/set-image/rollout undo — 30 phút/ngày" "ckad,drill" "CKAD"
create_issue "[PHASE 1][W5] KodeKloud CKAD — Module 6–8: Services, Storage, Security" "Nguồn: Udemy KodeKloud\nNội dung: ClusterIP/NodePort/LB, PV/PVC, SecurityContext, ServiceAccount" "ckad,udemy" "CKAD"
create_issue "[PHASE 1][W5] LabEx: Storage & Network labs" "Nguồn: labex.io\nNội dung: PVC binding, NetworkPolicy, ServiceAccount RBAC" "ckad,labex" "CKAD"
create_issue "[PHASE 1][W6] KodeKloud CKAD — Helm & Jobs/CronJobs ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: Helm install/upgrade/package; Jobs, CronJobs, DaemonSets" "ckad,udemy,new-2026" "CKAD"
create_issue "[PHASE 1][W6] LabEx: Managing Apps with Helm" "Nguồn: labex.io\nNội dung: Helm chart labs" "ckad,labex,new-2026" "CKAD"
create_issue "[PHASE 1][W6] CKAD Mock Exam 1 — KodeKloud" "Nội dung: Target >65% trong 2 giờ. Ghi lại topic sai" "ckad,mock-exam" "CKAD"
create_issue "[PHASE 1][W7] Ôn điểm yếu từ Mock 1" "Nội dung: Focus Observability, Helm, NetworkPolicy" "ckad,drill" "CKAD"
create_issue "[PHASE 1][W7] Killer.sh CKAD Simulator — 36h" "Nội dung: Làm đủ, review từng câu kể cả câu đúng" "ckad,mock-exam" "CKAD"
create_issue "[PHASE 1][W7] 🎯 THI CKAD" "Nội dung: Pass score 66%. Target 75+. Dùng kubernetes.io trong thi" "ckad" "CKAD"

# --- PHASE 2 (CKA) ---
create_issue "[PHASE 2][W8] KodeKloud CKA — Cluster Architecture + kubeadm ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: etcd, kube-apiserver, scheduler, controller-manager; kubeadm init/join/upgrade" "cka,udemy,new-2026" "CKA"
create_issue "[PHASE 2][W8] LabEx: Set Up K8s Cluster with kubeadm" "Nguồn: labex.io\nNội dung: Multi-node cluster bootstrap — bắt buộc cho CKA 2026" "cka,labex,new-2026" "CKA"
create_issue "[PHASE 2][W9] KodeKloud CKA — Workloads & Scheduling" "Nguồn: Udemy KodeKloud\nNội dung: Node Affinity, Taints/Tolerations, Resource Quotas, Static Pods, DaemonSets" "cka,udemy" "CKA"
create_issue "[PHASE 2][W9] LabEx: Scheduling & Affinity labs" "Nguồn: labex.io\nNội dung: Node selector, taint tolerance, priority class" "cka,labex" "CKA"
create_issue "[PHASE 2][W10] KodeKloud CKA — Networking" "Nguồn: Udemy KodeKloud\nNội dung: CNI, CoreDNS, Service networking, Ingress" "cka,udemy" "CKA"
create_issue "[PHASE 2][W10] KodeKloud CKA — Gateway API ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: GatewayClass, Gateway, HTTPRoute — topic mới chiếm ~50% đề" "cka,udemy,new-2026" "CKA"
create_issue "[PHASE 2][W10] LabEx: Kubernetes Networking Skill Tree" "Nguồn: labex.io\nNội dung: NetworkPolicy, DNS debug, Gateway API labs" "cka,labex,new-2026" "CKA"
create_issue "[PHASE 2][W11] KodeKloud CKA — Storage: Dynamic Provisioning ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: PV/PVC, StorageClass, Dynamic Provisioning" "cka,udemy,new-2026" "CKA"
create_issue "[PHASE 2][W11] KodeKloud CKA — RBAC & Security" "Nguồn: Udemy KodeKloud\nNội dung: TLS, kubeconfig, ClusterRole/RoleBinding, Admission Controllers" "cka,udemy" "CKA"
create_issue "[PHASE 2][W11] LabEx: RBAC + Security labs" "Nguồn: labex.io\nNội dung: ServiceAccount, RBAC, kubeconfig context switching" "cka,labex" "CKA"
create_issue "[PHASE 2][W12] KodeKloud CKA — Helm advanced + Kustomize ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: Helm lifecycle, Kustomize overlays/patches" "cka,udemy,new-2026" "CKA"
create_issue "[PHASE 2][W12] KodeKloud CKA — CRDs + Operators ⚠️" "Nguồn: Udemy KodeKloud\nNội dung: Custom Resource Definitions, Operator pattern" "cka,udemy,new-2026" "CKA"
create_issue "[PHASE 2][W12] LabEx: Kustomize + Helm advanced + CRD labs" "Nguồn: labex.io\nNội dung: Overlay patterns, Helm hooks, CRD creation" "cka,labex,new-2026" "CKA"
create_issue "[PHASE 2][W13] KodeKloud CKA — Troubleshooting (30% đề thi)" "Nguồn: Udemy KodeKloud\nNội dung: Node failure, pod crash, DNS/networking, etcd restore, control plane debug" "cka,udemy" "CKA"
create_issue "[PHASE 2][W13] LabEx: Kubernetes Troubleshooting labs" "Nguồn: labex.io\nNội dung: Cluster broken scenarios: node down, OOMKilled, CrashLoop" "cka,labex" "CKA"
create_issue "[PHASE 2][W13] CKA Mock Exam 1 + 2 — KodeKloud" "Nội dung: Target >70% mỗi exam. Ghi lại topic sai" "cka,mock-exam" "CKA"
create_issue "[PHASE 2][W14] Ôn sâu: Troubleshooting + Helm/Kustomize/Gateway API" "Nội dung: 3 topic make-or-break của CKA 2026\nLabel: cka,drill,new-2026" "cka,drill,new-2026" "CKA"
create_issue "[PHASE 2][W14] Killer.sh CKA Simulator — cả 2 lần kích hoạt" "Nội dung: Review tất cả solution kể cả câu đúng" "cka,mock-exam" "CKA"
create_issue "[PHASE 2][W14] 🎯 THI CKA" "Nội dung: Pass score 66%. Target 74+. Dùng kubernetes.io + helm.sh docs" "cka" "CKA"

echo "🎉 HOÀN THÀNH! Vui lòng làm mới trang (F5) Repository GitHub của bạn để xem 37 Issues."
