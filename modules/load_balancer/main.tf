resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = var.neg_name[count.index]
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.cloud_run_name[count.index]
  }
  count = length(var.cloud_run_name)
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = var.backend_service_name[count.index]
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

  count = length(var.backend_service_name)
}

resource "google_compute_region_url_map" "url_map" {
  name   = var.lb_name
  region = var.region

  default_service = google_compute_region_backend_service.backend_service.id 

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }

  path_matcher {
    name = "path-matcher-1"

    default_service = google_compute_region_backend_service.backend_service.id

    path_rule {
      paths   = ["/upload"]
      service = google_compute_region_backend_service.backend_service.id
    }
  }
}

resource "google_compute_region_ssl_certificate" "ssl_cert" {
  region      = var.region
  name        = var.certificate_name
  private_key = file(var.private_key_file)
  certificate = file(var.cert_file)
}

resource "google_compute_subnetwork" "proxy_subnet" {
  name          = var.subnet_name
  region        = var.region
  ip_cidr_range = var.ip_range
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = var.network_id
}

resource "google_compute_region_target_https_proxy" "https_proxy" {
  name    = var.http_proxy_name
  region  = var.region
  url_map = google_compute_region_url_map.url_map.id
  ssl_certificates = [ google_compute_region_ssl_certificate.ssl_cert.id ]
  depends_on = [ google_compute_region_ssl_certificate.ssl_cert ]
}

resource "google_compute_forwarding_rule" "https_forwarding_rule" {
  name                  = var.https_forwarding_rule_name
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  target                = google_compute_region_target_https_proxy.https_proxy.self_link
  port_range            = "443"
  network               = var.vpc_name
  subnetwork            = var.subnet_private_name
}
