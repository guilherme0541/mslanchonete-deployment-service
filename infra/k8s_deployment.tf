
resource "kubernetes_deployment" "test" {
  metadata {
    name = "nginx"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "guimaj/sistema-lanchonete:latest"
          name  = "app-lanchonete"
          port {
            container_port = 8080
          }
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

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://${data.aws_db_instance.database.endpoint}/${data.aws_db_instance.database.db_name}"
          }

          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = data.aws_db_instance.database.master_username
          }

          env {
            name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
            value = "update"
          }

          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "${var.project_name}-secret-database"
                key  = "password"
              }
            }
          }
          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 8080
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}