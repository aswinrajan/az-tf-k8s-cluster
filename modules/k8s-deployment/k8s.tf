provider "kubernetes" {
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}

resource "kubernetes_deployment" "test-deployment" {
  metadata {
    name = "test-deployment"
    labels = {
      test = "TestApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "TestApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "TestApp"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "test"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test-service" {
  metadata {
    name = "test-deployment"
  }
  spec {
    selector = {
      test = "TestApp"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}