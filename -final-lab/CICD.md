# CI/CD Design (Thiết kế luồng CI/CD)

Tài liệu mô tả thiết kế luồng CI/CD với các check-gates, tích hợp Git (Gitea/GitHub) và Registry, và mô hình triển khai Pull-based (ArgoCD).

---

## 1. Tổng quan luồng CI/CD

Luồng gồm các giai đoạn (check-gates) theo thứ tự: **UT → Lint → Build → Package → Dockerization → Release/Deploy**. Code được đẩy lên Git (Gitea hoặc GitHub); CI build, test, đóng gói và đẩy image lên Registry; triển khai dùng mô hình **Pull-based** (cluster tự kéo manifest và image).

```
  ┌─────────────┐     push/PR     ┌─────────────┐     trigger      ┌─────────────┐
  │   Developer │ ───────────────►│  Git        │ ────────────────►│  CI         │
  │             │                 │ (Gitea /    │  (webhook/poll)  │ (Jenkins)   │
  └─────────────┘                 │  GitHub)    │                  └──────┬──────┘
                                  └─────────────┘                         │
                                                                          │ UT, Lint, Build,
                                                                          │ Package, Dockerize,
                                                                          │ Push image
                                                                          ▼
  ┌─────────────┐     pull         ┌─────────────┐     pull         ┌─────────────┐
  │  Kubernetes │ ◄────────────────│  ArgoCD     │ ◄────────────────│  Git        │
  │  Cluster    │  (deploy app)    │  (Pull-based│  (manifests +    │  (manifests)│
  │             │                  │   deploy)   │   image tags)    │             │
  └──────┬──────┘                  └──────┬──────┘                  └─────────────┘
         │                                │
         │ pull image                     │
         ▼                                │
  ┌─────────────┐                         │
  │  Registry   │ ◄───────────────────────┘
  │ (Docker     │   CI pushes image
  │  registry)  │
  └─────────────┘
```

---

## 2. Các check-gates trong pipeline

Pipeline hiện tại (Jenkinsfile) triển khai các gate sau:

| Gate | Mô tả | Cách thực hiện trong repo |
|------|--------|----------------------------|
| **UT (Unit Tests)** | Kiểm thử đơn vị backend và frontend. | Backend: `go test -v ./...`. Frontend: `CI=true npm test -- --watchAll=false --passWithNoTests`. |
| **Lint** | Kiểm tra mã nguồn (style, lỗi cơ bản). | Backend: `go vet ./...`. Frontend: `npm run lint` (eslint). |
| **Build** | Biên dịch/đóng gói ứng dụng. | Backend: `CGO_ENABLED=0 go build -o server`. Frontend: `npm ci` + `npm run build`. |
| **Package** | Tạo artifact có thể lưu trữ. | Frontend: `npm pack`. Backend: tarball chứa binary. Artifact lưu vào `dist/` và archive trong Jenkins. |
| **Dockerization** | Build Docker image từ Dockerfile. | `docker build` cho `frontend` và `backend`, tag theo version và `latest`. |
| **Release/Deploy** | Đẩy image lên Registry (Release); triển khai (Deploy) qua ArgoCD. | **Release:** `docker push` tới Registry (param `LOCAL_REGISTRY`). **Deploy:** Pull-based bởi ArgoCD (xem mục 4). |

Thứ tự thực thi: **Unit Tests → Lint → Build → Package → Dockerization → Push to Registry**. Deploy không chạy trong cùng pipeline Jenkins mà do ArgoCD kéo manifest và image (Pull-based).

---

## 3. Tích hợp CI/CD với Git và Registry

### 3.1 Git (Gitea / GitHub)

- **Repository:** Code ứng dụng (frontend, backend) và cấu hình triển khai (manifest, monitoring) nằm trong cùng repo (ví dụ `-final-lab`).
- **Trigger CI:**
  - **Webhook:** Gitea/GitHub gửi webhook tới Jenkins khi có push hoặc merge PR (branch có thể cấu hình, ví dụ `main`).
  - **Poll SCM (thay thế):** Jenkins định kỳ kiểm tra thay đổi trên branch.
- **Jenkins:** Pipeline được định nghĩa bởi `Jenkinsfile` trong repo (Pipeline from SCM). Credential Git (username/password hoặc SSH key) cấu hình trong Jenkins.

### 3.2 Registry (Lưu Docker image)

- **Vị trí:** Image sau bước Dockerization được push lên Docker Registry (local hoặc cloud).
- **Tham số:** Pipeline dùng parameter `LOCAL_REGISTRY` (mặc định `localhost:5000`); có thể đổi thành Gitea Container Registry, GitHub Container Registry (ghcr.io), hoặc registry công ty.
- **Xác thực:** Jenkins credential ID `local-registry-credentials` (username/password) dùng cho `docker login` trước khi push. Với registry không bảo mật (insecure), vẫn có thể dùng credential giả để Jenkins không lỗi bước login.

---

## 4. Mô hình Pull-based Deployment (ArgoCD)

### 4.1 Nguyên tắc

- **Push-based (truyền thống):** CI/CD server (Jenkins) SSH/kubectl vào cluster để apply manifest và rollout. Cluster “bị động”.
- **Pull-based:** Tool chạy trong cluster (ArgoCD) định kỳ so sánh Git (và/hoặc Kustomize/Helm) với trạng thái cluster và **tự kéo** thay đổi để đồng bộ. Cluster “chủ động” kéo desired state từ Git.

### 4.2 Luồng với ArgoCD

1. **Git** chứa:
   - Manifest Kubernetes (thư mục `manifest/`, `monitoring/`) và có thể Kustomize/Helm.
   - Image tag có thể cập nhật trong manifest (ví dụ `image: registry.io/frontend:20250304-123456`) do CI ghi lại sau khi build, hoặc ArgoCD dùng image updater để đổi tag theo Registry.
2. **ArgoCD** cấu hình Application trỏ tới repo Git (và path manifest). ArgoCD định kỳ pull Git, so sánh với cluster, rồi apply diff.
3. **Kubernetes** kéo image từ Registry khi rollout Deployment (imagePullPolicy phù hợp, ví dụ Always khi dùng tag động).

### 4.3 Lợi ích

- Một nguồn sự thật: Git là nguồn desired state; audit, rollback đều dựa trên Git.
- Cluster không cần mở cổng cho Jenkins; chỉ cần ArgoCD có quyền đọc Git (và cluster apply resource).
- Phù hợp với GitOps: mọi thay đổi triển khai qua commit/PR.
