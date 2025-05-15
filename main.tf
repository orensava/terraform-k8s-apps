# Configure the Kubernetes provider with local kubeconfig
provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

# Deploy app1 with 3 replicas, exposed on NodePort 30000
module "app1" {
  source         = "./modules/app"
  app_name       = "app1"
  replicas       = 3
  container_port = 5678
  node_port      = 30000
}

# Deploy app2 with 2 replicas, exposed on NodePort 30001
module "app2" {
  source         = "./modules/app"
  app_name       = "app2"
  replicas       = 2
  container_port = 5678
  node_port      = 30001
}
