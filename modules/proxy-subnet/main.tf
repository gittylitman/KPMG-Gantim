resource "google_compute_subnetwork" "proxy_subnet" {
  name          = var.subnet_name
  region        = var.region
  ip_cidr_range = var.ip_range
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = var.network_id
}
