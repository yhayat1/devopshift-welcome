# Helm chart – Crypto app

One chart deploys **frontend**, **backend**, and **MySQL**. No extra helpers or generated files; only what’s needed to run.

## What’s in the chart

| File | Purpose |
|------|--------|
| `Chart.yaml` | Chart name and version |
| `values.yaml` | Replica counts and database credentials (all config here) |
| `templates/frontend-deployment.yaml` | Frontend Deployment |
| `templates/frontend-service.yaml` | Frontend Service (ClusterIP) |
| `templates/backend-deployment.yaml` | Backend Deployment + MySQL env |
| `templates/backend-service.yaml` | Backend Service (ClusterIP) |
| `templates/mysql-deployment.yaml` | MySQL Deployment |
| `templates/mysql-service.yaml` | MySQL Service (ClusterIP) |

Service names are fixed (`frontend-service`, `backend-service`, `mysql-service`) so the app works without code changes.

## Configuration (values.yaml)

- **Replica counts:** `frontend.replicaCount`, `backend.replicaCount`, `mysql.replicaCount`
- **Database credentials:**  
  - Backend → MySQL: `mysqlHost`, `mysqlUser`, `mysqlPassword`  
  - MySQL: `mysqlRootPassword`, `mysqlDatabase`

Change these in `values.yaml` or override at install/upgrade.

## Install

```bash
# From repo root
helm install crypto exam-code/k8s/helm/crypto-app/
```

## Override replica count or credentials

```bash
helm install crypto exam-code/k8s/helm/crypto-app/ \
  --set frontend.replicaCount=3 \
  --set mysqlPassword=secret123 \
  --set mysqlRootPassword=secret123
```

Or use a custom file: `helm install crypto exam-code/k8s/helm/crypto-app/ -f my-values.yaml`

## Upgrade / uninstall

```bash
helm upgrade crypto exam-code/k8s/helm/crypto-app/
helm uninstall crypto
```

## Access the app

After install, port-forward and open http://localhost:5002:

```bash
kubectl port-forward svc/frontend-service 5002:5002
```
