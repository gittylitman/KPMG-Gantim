

resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "cloud-run-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.cloud_run_name
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = "internal-backend-service"
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }
}

resource "google_compute_region_url_map" "url_map" {
  name            = "internal-url-map"
  region          = var.region
  default_service = google_compute_region_backend_service.backend_service.id
}

