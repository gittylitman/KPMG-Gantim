

resource "google_compute_region_network_endpoint_group" "cloud_run_neg_admin" {
  name                  = "cloud-run-admin-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = "admin-cr"
  }
}

resource "google_compute_region_backend_service" "backend_service_admin" {
  name                  = "internal-backend-service_admin"
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg_admin.id
  }
}

resource "google_compute_region_network_endpoint_group" "cloud_run_neg_citizen" {
  name                  = "cloud-run-neg-citizen"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = "citizen-cr"
  }
}

resource "google_compute_region_backend_service" "backend_service_citizen" {
  name                  = "internal-backend-service-citizen"
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg_citizen.id
  }
}

resource "google_compute_region_url_map" "url_map" {
  name   = "internal-url-map"
  region = var.region

  default_service = google_compute_region_backend_service.backend_service_admin.id  # ברירת מחדל: admin-cr

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }

  path_matcher {
    name = "path-matcher-1"

    default_service = google_compute_region_backend_service.backend_service_admin.id  # ברירת מחדל: admin-cr

    path_rule {
      paths   = ["/citizen"]
      service = google_compute_region_backend_service.backend_service_citizen.id
    }
  }
}

# resource "google_compute_managed_ssl_certificate" "ssl_cert" {
#   name    = "my-managed-ssl-cert"
#   managed {
#     domains = ["sslcert.tf"]
#   }
# }

# resource "google_compute_region_target_https_proxy" "https_proxy" {
#   name    = "internal-https-proxy"
#   region  = var.region
#   url_map = google_compute_region_url_map.url_map.id
#   ssl_certificates = [ google_compute_managed_ssl_certificate.ssl_cert.id ]
#   depends_on = [ google_compute_managed_ssl_certificate.ssl_cert ]
# }

# resource "google_compute_forwarding_rule" "https_forwarding_rule" {
#   name                  = "internal-https-forwarding-rule"
#   region                = var.region
#   load_balancing_scheme = "INTERNAL_MANAGED"
#   target                = google_compute_region_target_https_proxy.https_proxy.id
#   port_range            = "443"
#   network               = var.vpc_name
#   subnetwork            = var.subnet_name
# }
