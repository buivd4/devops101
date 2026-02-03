resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask-deployment"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          image = var.flask_image
          name  = "flask"
          image_pull_policy = "Never"
          }
        }
      }
    }
}

resource "kubernetes_service" "flask"{
  metadata {
    name = "flask-svc"
  }
  spec {
    type = "ClusterIP"
    port {
      port = 80
      target_port = 8080
    }
    selector = {
      app = "flask"
    }
  }
}
