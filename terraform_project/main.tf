terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}

provider "google" {
  project = var.project_id
}

module "network" {
  source = "../modules/network"
  vpc_name = var.vpc_name
  subnetwork_name = var.subnet_name
  region = var.region
  ip_cidr_range = var.ip_cidr_range
}

module "cloud_run" {
  source = "../modules/cloud_run"
  cloud_run_name = var.cloud_run_names[count.index]
  location = var.region
  container_image = var.container_image
  vpc_access_connector_name = var.access_connector_names[count.index]
  subnet_name = module.network.subnet_name
  connector_min_instances = var.connector_min_instances
  connector_max_instances = var.connector_max_instances
  count = length(var.cloud_run_names)
}

module "cloud_storage" {
  source = "../modules/cloud_storage"
  name = var.cloud_storage_name[count.index]
  location = var.region
  count = length(var.cloud_storage_name)
}
