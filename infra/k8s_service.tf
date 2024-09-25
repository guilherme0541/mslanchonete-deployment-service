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

# # Create a local variable for the load balancer name.
# locals {
#   lb_name = split("-", split(".", kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname).0).0
# }

# # Read information about the load balancer using the AWS provider.
# data "aws_elb" "example" {
#   name = local.lb_name
# }

# output "load_balancer_name" {
#   value = local.lb_name
# }

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

# output "load_balancer_info" {
#   depends_on = [ data.kubernetes_service.example ]
#   value = data.aws_elb.example
# }