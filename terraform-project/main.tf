terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}

resource "google_project_service" "cloudresourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

module "network" {
  source = "../modules/network"
  vpc_name = "gantim"
  subnetwork_name = "snet-gantim"
  region = var.location
  ip_cidr_range = "10.1.0.0/24"
}

module "cloud_run" {
  source = "../modules/cloud-run"
  cloud_run_name = var.cloud_run_name[count.index]
  location = var.location
  container_image = "us-docker.pkg.dev/cloudrun/container/hello"
  vpc_access_connector_name = var.access_connector_name[count.index]
  subnet_name = module.network.subnet_name
  count = length(var.cloud_run_name)
  depends_on = [ google_project_service.cloudresourcemanager ]
}
