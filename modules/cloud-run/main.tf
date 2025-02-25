resource "google_cloud_run_v2_service" "cloud_run"{
  name = var.cloud_run_name
  location = var.location
  deletion_protection = false
  template {
    containers {
      image = var.container_image
    }
  }
}
