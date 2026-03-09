# Monitoring Stack: Loki, Grafana, Prometheus, kube-state-metrics

Kubernetes manifests are grouped by system so you can see which configuration belongs to which component.

## Folder layout

| Folder | System | Contents |
|--------|--------|----------|
| **base/** | Shared | Namespace and other cluster-wide basics. |
| **loki/** | Loki | Config + Deployment/Service (log aggregation). |
| **grafana/** | Grafana | Datasources, dashboard provider, deployment, and dashboard ConfigMaps (K8s + ArgoCD). |
| **prometheus/** | Prometheus | RBAC, config, Deployment/Service (metrics scraping). |
| **kube-state-metrics/** | kube-state-metrics | RBAC + Deployment/Service (K8s object metrics). |

## Components

| Component | Description |
|-----------|-------------|
| **Loki** | Log aggregation (Grafana Loki). |
| **Grafana** | Dashboards and UI; datasources: Prometheus (default), Loki. |
| **Prometheus** | Metrics collection; scrapes itself, kube-state-metrics, and optional ArgoCD. |
| **kube-state-metrics** | Exposes Kubernetes object metrics (deployments, pods, nodes, etc.). |

## Apply order

Apply **base** first, then **prometheus** (RBAC + config + deployment), **kube-state-metrics**, **loki**, and finally **grafana** (datasources, dashboards, then deployment):

```bash
kubectl apply -f base/
kubectl apply -f prometheus/
kubectl apply -f kube-state-metrics/
kubectl apply -f loki/
kubectl apply -f grafana/
```

Or apply the whole tree (order may matter; base and prometheus RBAC first):

```bash
kubectl apply -f base/
kubectl apply -f prometheus/rbac.yaml
kubectl apply -f prometheus/config.yaml
kubectl apply -f prometheus/deployment.yaml
kubectl apply -f kube-state-metrics/
kubectl apply -f loki/
kubectl apply -f grafana/
```

## Grafana dashboards (K8s resources)

- **grafana/dashboard-kubernetes.yaml** – Kubernetes cluster (kube-state-metrics: nodes, pods, deployments, namespaces, replicas, pod phases). Datasource: Prometheus.
- **grafana/dashboard-argocd.yaml** – ArgoCD overview (app count, Synced/OutOfSync). Requires ArgoCD installed and scraped by Prometheus (job `argocd-metrics` in **prometheus/config.yaml**).

## Accessing Grafana

- **ClusterIP**: `kubectl port-forward -n monitoring svc/grafana 3000:3000`, then open http://localhost:3000.
- Default credentials (from `grafana-admin` secret): **admin** / **admin**. Change in production.

## ArgoCD metrics

If ArgoCD is in namespace `argocd` and exposes metrics on `argocd-metrics:8082`, the Prometheus config in **prometheus/config.yaml** will scrape it. Adjust the `argocd-metrics` job there if your service name or port differs.

## Logs (Loki)

Grafana is provisioned with a Loki datasource (`http://loki.monitoring.svc.cluster.local:3100`). You still need a log collector (e.g. Promtail) to ship logs to Loki; these manifests do not include it.
