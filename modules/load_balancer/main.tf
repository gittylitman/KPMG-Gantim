resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on = [ google_project_service.compute ]
}


resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = var.neg_name[count.index]
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.cloud_run_name[count.index]
  }
  count = length(var.cloud_run_name)
  depends_on = [ time_sleep.wait_60_seconds ]
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = var.backend_service_name[count.index]
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg[count.index].id
  }
  count = length(var.backend_service_name)
}

resource "google_compute_region_url_map" "url_map" {
  name   = var.lb_name
  region = var.region

  default_service = google_compute_region_backend_service.backend_service[1].id 

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }

  path_matcher {
    name = "path-matcher-1"

    default_service = google_compute_region_backend_service.backend_service[1].id

    path_rule {
      paths   = ["/upload"]
      service = google_compute_region_backend_service.backend_service[0].id
    }
  }
}

data "google_compute_region_ssl_certificate" "ssl_cert" {
  name        = var.certificate_name
  region = var.region
}

data "google_compute_subnetwork" "proxy_subnet" {
  name          = var.subnet_name
  region        = var.region
  project = var.host_project_id
}

resource "google_compute_region_target_https_proxy" "https_proxy" {
  name    = var.http_proxy_name
  region  = var.region
  url_map = google_compute_region_url_map.url_map.id
  ssl_certificates = [ data.google_compute_region_ssl_certificate.ssl_cert.id ]
  depends_on = [ data.google_compute_region_ssl_certificate.ssl_cert ]
}

resource "google_compute_forwarding_rule" "https_forwarding_rule" {
  name                  = var.https_forwarding_rule_name
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  target                = google_compute_region_target_https_proxy.https_proxy.self_link
  port_range            = "443"
  network               = var.vpc_name
  subnetwork            = var.subnet_private_name
  depends_on = [ data.google_compute_subnetwork.proxy_subnet ]
}
