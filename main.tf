terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "this" {
  name = "terraform-cluster"
}

resource "local_file" "kubeconfig" {
  content  = kind_cluster.this.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

provider "kubernetes" {
  alias                  = "kube"
  config_path            = "${path.module}/kubeconfig.yaml"
}

module "apps" {
  source     = "./modules/app"
  for_each   = var.apps
  app_name   = each.key
  app_config = each.value

  providers = {
    kubernetes = kubernetes.kube
  }

  depends_on = [null_resource.wait_for_kubeconfig]
}

output "app_services" {
  value = {
    for app, cfg in var.apps :
    app => "http://localhost:${cfg.node_port}"
  }
}

output "app_node_ports" {
  value = {
    for app, mod in module.apps :
    app => mod.node_port
  }
}
resource "null_resource" "wait_for_kubeconfig" {
  triggers = {
    kubeconfig_sha = sha1(local_file.kubeconfig.content)
  }
}