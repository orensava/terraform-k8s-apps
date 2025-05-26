terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.app_config.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = "stefanprodan/podinfo:6.5.3"
          port {
            container_port = var.app_config.container_port
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = var.app_config.container_port
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 2
          }

          readiness_probe {
            http_get {
              path = "/readyz"
              port = var.app_config.container_port
            }
            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 2
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name = "${var.app_name}-svc"
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "NodePort"

    port {
      port        = var.app_config.container_port
      target_port = var.app_config.container_port
      node_port   = var.app_config.node_port
    }
  }
}
