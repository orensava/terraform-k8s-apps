# Create a Kubernetes Deployment for the application
resource "kubernetes_deployment" "app" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

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
          image = "hashicorp/http-echo"

          args = [
            "-listen=:5678",
            "-text=${var.app_name} running"
          ]

          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

# Expose the app using a NodePort service
resource "kubernetes_service" "app_service" {
  metadata {
    name = "${var.app_name}-svc"
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "NodePort"

    port {
      port        = 5678
      target_port = 5678
      node_port   = var.node_port
    }
  }
}
