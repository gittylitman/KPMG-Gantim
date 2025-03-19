resource "google_cloud_run_v2_service" "front_cloudrun" {
  name     = var.front_cloud_run_name
  location = var.location
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false

  template {
    containers {
      ports {
        container_port = 80
      }
      image = var.front_container_image
    }

    vpc_access {
      network_interfaces {
        network = var.network_name
        subnetwork = var.subnetwork_name
        tags = []
      }
    }
  }
}
