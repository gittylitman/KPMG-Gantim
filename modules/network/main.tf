data "google_compute_network" "vpc_network" {
  name         = var.vpc_name
  project = var.host_project_id
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name[count.index]
  region        = var.region
  ip_cidr_range = var.ip_cidr_range[count.index]
  network       = data.google_compute_network.vpc_network.id
  private_ip_google_access = true
  purpose = "PRIVATE"
  count = length(var.subnetwork_name)
  project = var.host_project_id
}
