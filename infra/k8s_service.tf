resource "kubernetes_service" "nginx" {
  depends_on = [kubernetes_deployment.test]
  metadata {
    name = "nginx"
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      # node_port   = 80
      port        = 80
      target_port = 8080
    }
  }
}

data "kubernetes_service" "example" {
  depends_on = [kubernetes_service.nginx]
  metadata {
    name = "nginx"
  }
}

output "load_balancer_hostname" {
  depends_on = [data.kubernetes_service.example]
  value      = data.kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname
}