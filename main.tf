# Cloud Run service resource
resource "google_cloud_run_service" "service1" {
  project =  "qwiklabs-gcp-02-28c19ba663d3"
  name     = "service1"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/my-project/my-image:latest"

        # KCC configuration
        env {
          name  = "KCC_ENABLE"
          value = "true"
        }
        env {
          name  = "KCC_HOST"
          value = "127.0.0.1"
        }
        env {
          name  = "KCC_PORT"
          value = "9090"
        }
      }
    }
  }
}

# Helm chart resource
resource "helm_release" "my_chart" {
  name       = "my-chart"
  repository = "https://charts.example.com"
  chart      = "my-chart"
  version    = "1.0.0"

  values = [
    jsonencode({
      # KCC configuration for Helm chart
      kcc: {
        enabled: true,
        host: "127.0.0.1",
        port: 9090,
      }
    })
  ]


  depends_on = [
    google_cloud_run_service.service1,
  ]
}
