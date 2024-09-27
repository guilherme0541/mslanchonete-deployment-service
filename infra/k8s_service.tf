resource "kubernetes_service" "service" {
  depends_on = [kubernetes_deployment.test]
  metadata {
    name = "${var.project_name}-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      # node_port   = 80
      port        = 80
      target_port = 8080
    }
  }
}

data "kubernetes_service" "service" {
  depends_on = [kubernetes_service.service]
  metadata {
    name = "${var.project_name}-service"
  }
}

resource "kubernetes_ingress" "ingress"{
  wait_for_load_balancer = true
  metadata {
    name = "${var.project_name}-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/load-balancer-name" = "${var.project_name}-ingress"
    }
  }

  spec{
    default_backend {
      service {
        name = "${var.project_name}-service"
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "${var.project_name}-service"
              port {
                number = 80
              }
            }
          }
          path = "/*"
        }
      }
    }
  }
}

output "load_balancer_hostname" {
  depends_on = [data.kubernetes_service.service, kubernetes_ingress.ingress]
  value      = kubernetes_ingress.ingress.status
}