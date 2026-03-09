# System Design (Thiết kế hệ thống)

Tài liệu mô tả thiết kế hệ thống bao gồm các thành phần ứng dụng hiện có, các thành phần bổ trợ trên Kubernetes (Service, Pod, v.v.) và stack giám sát (Loki, Grafana, Prometheus, kube-state-metrics, ArgoCD).

---

## 1. Các thành phần hiện có trong hệ thống (Application)

| Thành phần | Công nghệ | Vai trò |
|------------|-----------|---------|
| **Frontend** | React (Node 14) | Giao diện người dùng, gọi API backend qua reverse proxy. |
| **Backend** | Go (Gin) | API server, kết nối Redis và PostgreSQL. |
| **Reverse Proxy** | Nginx 1.19 | Phân luồng: `/` → frontend, `/api/` → backend. |
| **Redis** | redis:alpine | Cache in-memory cho backend. |
| **PostgreSQL** | postgres:13.2-alpine | Cơ sở dữ liệu chính cho backend. |

**Luồng truy cập:** User → Reverse Proxy (port 80) → Frontend (5000) hoặc Backend (8080). Backend dùng Redis và PostgreSQL trong cluster.

---

## 2. Các thành phần bổ trợ (Kubernetes & Hạ tầng)

### 2.1 Kubernetes – Workload & Networking

| Thành phần K8s | Áp dụng cho | Mô tả |
|----------------|-------------|--------|
| **Namespace** | (optional) | Nhóm resource (ví dụ `default`, `monitoring`). |
| **Deployment** | frontend, backend, reverse-proxy, redis, postgres | Khai báo Pod template, replicas, image, env. |
| **Pod** | Mỗi container chạy trong Pod | Đơn vị triển khai nhỏ nhất; chứa 1 hoặc nhiều container. |
| **Service** | Tất cả service app + monitoring | ClusterIP (nội bộ) hoặc LoadBalancer (reverse-proxy) để truy cập Pod. |
| **ConfigMap** | nginx (reverse-proxy), Loki, Prometheus, Grafana | Cấu hình dạng key-value hoặc file (ví dụ `nginx.conf`). |
| **Secret** | grafana-admin, postgres (nếu cần) | Thông tin nhạy cảm (mật khẩu, token). |
| **PersistentVolumeClaim (PVC)** | postgres | Gắn volume lưu trữ cho dữ liệu PostgreSQL. |

### 2.2 Thành phần phục vụ Monitoring

| Thành phần | Vai trò |
|------------|--------|
| **Loki** | Thu thập và lưu trữ log (tương thích Grafana); nhận log từ log shipper (ví dụ Promtail). |
| **Grafana** | Giao diện truy vấn log (Loki), xem dashboard metrics (Prometheus); datasource: Prometheus + Loki. |
| **Prometheus** | Thu thập metrics (scrape) từ các target: bản thân Prometheus, kube-state-metrics, ArgoCD (nếu có). |
| **kube-state-metrics** | Exporter metrics từ API server K8s (deployments, pods, nodes, namespaces, v.v.) cho Prometheus. |
| **Grafana Dashboards** | Dashboard K8s (kube-state-metrics) và ArgoCD (ứng dụng, sync status) dưới dạng ConfigMap. |

---

## 3. Mô hình triển khai (Deployment Model)

- **Ứng dụng:** Chạy trong Kubernetes dưới dạng Deployment + Service; reverse-proxy expose ra ngoài (LoadBalancer/NodePort).
- **Monitoring:** Chạy trong namespace `monitoring` (Loki, Grafana, Prometheus, kube-state-metrics).
- **Log:** Ứng dụng → (log shipper, ví dụ Promtail) → Loki; người dùng xem log trên Grafana (datasource Loki).
- **Metrics:** kube-state-metrics & ArgoCD metrics → Prometheus scrape → Grafana (datasource Prometheus) hiển thị dashboard.

---

## 4. Sơ đồ kiến trúc hệ thống (System Architecture)

```
                                    ┌──────────────────────────────────────────────────────────────┐
                                    │                     Kubernetes Cluster                       │
                                    │                                                              │
  ┌──────────┐    HTTP :80          │  ┌─────────────────┐      /api/*       ┌─────────────────┐   │
  │  User    │ ────────────────────►│  │ Reverse Proxy   │ ─────────────────►│    Backend      │   │
  │ (Browser)│                      │  │ (Nginx)         │                   │    (Go :8080)   │   │
  └──────────┘                      │  │ LoadBalancer    │                   │                 │   │
         │                          │  └────────┬────────┘                   └───────┬─────────┘   │
         │                          │           │ /*                                 │             │
         │                          │           │                                    │             │
         │                          │           ▼                                    │             │
         │                          │  ┌─────────────────┐                   ┌───────┴─────────┐   │
         │                          │  │    Frontend     │                   │ Redis │ Postgres│   │
         │                          │  │ (React :5000)   │                   └───────┬─────────┘   │
         │                          │  └─────────────────┘                           │             │
         │                          │                                                │             │
         │                          │  ═══════════════════════ MONITORING ═══════════════════════  │
         │                          │                                                              │
         │                          │  ┌─────────────┐    scrape     ┌──────────────────────┐      │
         │                          │  │ Prometheus  │◄──────────────│ kube-state-metrics   │      │
         │                          │  │   :9090     │               │ (K8s object metrics) │      │
         │                          │  └──────┬──────┘               └──────────────────────┘      │
         │                          │         │                                ▲                   │
         │                          │         │ scrape (optional)              │                   │
         │                          │         │                    ┌───────────┴───────────┐       │
         │                          │         │                    │ ArgoCD (argocd NS)    │       │
         │                          │         │                    │ metrics :8082         │       │
         │                          │         │                    └───────────────────────┘       │
         │                          │         ▼                                                    │
         │                          │  ┌─────────────┐     logs      ┌─────────────┐               │
         └─────────────────────────►│  │   Grafana   │◄──────────────│    Loki     │               │
                                    │  |   :3000     │  (datasource) │   :3100     │               │
                                    │  │             │◄──────────────│             │               │
                                    │  │ Dashboards: │  (datasource) │ Log storage │               │
                                    │  │ • K8s       │               │ (← Promtail │               │
                                    │  │ • ArgoCD    │               │   / shipper)│               │
                                    │  └─────────────┘               └─────────────┘               │
                                    |                                                              │
                                    └──────────────────────────────────────────────────────────────┘
                                     Port-forward / Ingress: Grafana, Reverse Proxy
```

**Chú thích:**

- **Application:** User vào Reverse Proxy; Nginx chuyển `/api/` sang Backend, còn lại sang Frontend. Backend nói chuyện Redis và PostgreSQL trong cluster.
- **Monitoring – Metrics:** Prometheus scrape: chính nó, kube-state-metrics (K8s), và (nếu cài) ArgoCD metrics. Grafana dùng Prometheus làm datasource cho dashboard K8s và ArgoCD.
- **Monitoring – Logs:** Log từ Pod/container được ship tới Loki (qua Promtail hoặc log shipper khác). Grafana dùng Loki làm datasource để truy vấn log.

---

## 5. Cách giám sát (Monitoring Approach)

| Loại giám sát | Công cụ | Nguồn dữ liệu | Cách xem |
|---------------|---------|----------------|----------|
| **Logs** | Loki + Grafana | Log từ các service (qua Promtail/shipper) → Loki | Grafana → Explore → datasource Loki, query LogQL. |
| **K8s metrics** | kube-state-metrics + Prometheus + Grafana | Metrics từ API server (deployments, pods, nodes, …) | Grafana dashboard “Kubernetes Cluster (kube-state-metrics)”. |
| **ArgoCD** | Prometheus + Grafana | ArgoCD metrics endpoint (khi cài ArgoCD) | Grafana dashboard “ArgoCD Overview”. |

**Thư mục cấu hình:** `monitoring/` (chia theo từng hệ thống: `base/`, `loki/`, `grafana/`, `prometheus/`, `kube-state-metrics/`). Chi tiết apply và cách dùng xem `monitoring/README.md`.

---

## 6. Tóm tắt thành phần theo thư mục

| Thư mục / File | Thành phần | Ghi chú |
|----------------|------------|---------|
| `frontend/`, `backend/` | Ứng dụng | Source + Dockerfile. |
| `manifest/` | K8s app | Deployment + Service cho frontend, backend, reverse-proxy, redis, postgres. |
| `nginx.conf`, `manifest/` | Reverse proxy | ConfigMap Nginx, Deployment, Service LoadBalancer. |
| `monitoring/base/` | Namespace | `monitoring`. |
| `monitoring/loki/` | Loki | Config + Deployment + Service. |
| `monitoring/grafana/` | Grafana | Datasources (Prometheus, Loki), dashboard provider, Deployment, Service, dashboards K8s + ArgoCD. |
| `monitoring/prometheus/` | Prometheus | RBAC, config (scrape Prometheus, kube-state-metrics, ArgoCD), Deployment, Service. |
| `monitoring/kube-state-metrics/` | kube-state-metrics | RBAC + Deployment + Service. |

