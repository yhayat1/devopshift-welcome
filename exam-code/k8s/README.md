# Kubernetes deployment – Crypto app (FE, BE, MySQL)

This directory contains the Kubernetes manifests for the crypto price tracker app, migrated from Docker Compose.

## Task overview

- **Frontend**: Deployment with 2 replicas; Service type ClusterIP (external access via port-forward or NodePort if you change the service).
- **Backend**: Deployment with 2 replicas; internal ClusterIP Service.
- **MySQL**: Deployment with 1 replica; internal ClusterIP Service (env: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`).
- **Communication**: Frontend → Backend (`backend-service:5001`); Backend → MySQL (`mysql-service:3306`).

## Directory structure

```
k8s/
├── fe/
│   ├── deployment.yaml   # Frontend (2 replicas, port 5002)
│   └── service.yaml      # frontend-service (ClusterIP)
├── be/
│   ├── deployment.yaml   # Backend (2 replicas, port 5001, MySQL env)
│   └── service.yaml      # backend-service (ClusterIP)
├── mysql/
│   ├── deployment.yaml   # MySQL (1 replica, port 3306)
│   └── service.yaml      # mysql-service (ClusterIP)
└── README.md
```

## Prerequisites

- `kubectl` configured for your cluster.
- Cluster can pull:
  - `yossihayat/docker-web:1.0.0` (frontend)
  - `yossihayat/docker-backend-service:1.0.0` (backend)
  - `mysql:5.7` or `mysql:8.0` (see `mysql/deployment.yaml`; amd64-only images may require `nodeSelector: kubernetes.io/arch: amd64` on ARM clusters).

## Deploy

From the repo root (or the directory that contains `exam-code/`):

```bash
kubectl apply -f exam-code/k8s/
```

Or per component (MySQL first recommended):

```bash
kubectl apply -f exam-code/k8s/mysql/
kubectl apply -f exam-code/k8s/be/
kubectl apply -f exam-code/k8s/fe/
```

## Verify

```bash
kubectl get pods
kubectl get svc
```

Wait until all pods are `Running`.

## Accessing the application

The frontend Service is ClusterIP, so it is not exposed on a node port. Use one of the following.

### Same machine where you run kubectl (e.g. your laptop)

Run a port-forward and open the app on localhost:

```bash
kubectl port-forward svc/frontend-service 5002:5002
```

Then open: **http://localhost:5002**

### From another device (same network)

If the cluster is running on a machine that you access via `kubectl` from your laptop (or another workstation), you can still use port-forward and then reach the app from other devices:

1. On the machine that has `kubectl` and cluster access, run port-forward bound to all interfaces:

   ```bash
   kubectl port-forward --address 0.0.0.0 svc/frontend-service 5002:5002
   ```

2. From another device on the same network (phone, tablet, another PC), open a browser and go to:

   **http://\<IP-of-the-machine-running-port-forward\>:5002**

   Example: if the laptop running the command has IP `192.168.1.10`, use **http://192.168.1.10:5002**.

3. Ensure the machine running `kubectl port-forward` allows inbound TCP traffic on port 5002 (firewall/local network rules).

### When the cluster runs on a different host (e.g. cloud or lab server)

- **Option A – port-forward from your PC:**  
  Run `kubectl port-forward svc/frontend-service 5002:5002` on your PC (with `kubeconfig` pointing at that cluster). Then use **http://localhost:5002** on your PC only.

- **Option B – allow other devices to reach the app:**  
  On a machine that has `kubectl` and network path from other devices, run:

  ```bash
  kubectl port-forward --address 0.0.0.0 svc/frontend-service 5002:5002
  ```

  Other devices use **http://\<that-machine-IP\>:5002**.

## Operating the deployment

| Action              | Command |
|---------------------|--------|
| List pods           | `kubectl get pods` |
| List services       | `kubectl get svc` |
| Frontend logs       | `kubectl logs -l app=frontend -f` |
| Backend logs        | `kubectl logs -l app=backend -f` |
| MySQL logs          | `kubectl logs -l app=mysql -f` |
| Describe a resource | `kubectl describe pod <pod-name>` |
| Restart frontend    | `kubectl rollout restart deployment/fe-deployment` |
| Restart backend     | `kubectl rollout restart deployment/be-deployment` |
| Restart MySQL       | `kubectl rollout restart deployment/mysql-deployment` |

## Cleanup

Remove all resources created from this directory:

```bash
kubectl delete -f exam-code/k8s/
```

Or delete by label/name if you prefer.
