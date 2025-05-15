# Terraform Kubernetes App Deployment

This repository demonstrates how to use Terraform to deploy redundant applications on a local Kubernetes cluster using Kind.

The idea is to keep it simple, modular, and easy to extend.

---

# What's Included

- A Kind-based local Kubernetes cluster
- Two simple web apps (`app1` and `app2`) running as stateless HTTP echo servers
- Each app is deployed via a reusable Terraform module
- Services are exposed via NodePort and accessed using `kubectl port-forward`
- Bonus: Adding more apps requires minimal code

---

# Requirements

Make sure the following tools are installed and available in your path:

- [Kind](https://kind.sigs.k8s.io/)
- [Podman](https://podman.io/) (used to run Kind in rootless mode)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/) (1.3+ recommended)

---

# Getting Started


1. Create a Kind cluster (if you haven’t already):

```bash
kind create cluster --name terraform-cluster
```

2. Verify the cluster is running:

```bash
kubectl get nodes
```

3. Deploy the applications:

```bash
terraform init
terraform apply
```

---

# Accessing the Apps

Because we're using Kind on Podman, NodePort isn't directly accessible.  
Instead, we forward ports locally:

```bash
kubectl port-forward svc/app1-svc 8080:5678
```

In a separate terminal:

```bash
curl http://localhost:8080
```

Same for app2:

```bash
kubectl port-forward svc/app2-svc 8081:5678
curl http://localhost:8081
```

---

# Bonus – Add Another App

Want to add a third app? Just copy a module block in `main.tf`:

```hcl
module "app3" {
  source         = "./modules/app"
  app_name       = "app3"
  replicas       = 2
  container_port = 5678
  node_port      = 30002
}
```

That’s it — the module handles the rest.

---

# Cleanup

To tear down everything:

```bash
terraform destroy
kind delete cluster --name terraform-cluster
```

---

# Folder Structure

```
terraform-k8s-apps/
├── main.tf
├── variables.tf
├── outputs.tf
├── start.sh
├── modules/
│   └── app/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

# Notes

- Tested on macOS with Kind running on Podman
- Adjust `node_port` values if needed
