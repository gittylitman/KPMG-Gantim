data "google_compute_network" "vpc_network" {
  name         = var.vpc_name
  project = var.host_project_id
}

data "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_names[count.index]
  region        = var.region
  project = var.host_project_id
  count = length(var.subnetwork_names)
}
