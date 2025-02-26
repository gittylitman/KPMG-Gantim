resource "google_compute_network" "vpc_network" {
  name         = var.vpc_name
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.subnetwork_name
  region        = var.region
  ip_cidr_range = var.ip_cidr_range
  network       = google_compute_network.vpc_network.id
}
