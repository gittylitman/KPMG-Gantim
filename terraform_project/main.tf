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

module "cloud_storage" {
  source = "../modules/cloud_storage"
  name = var.cloud_storage_name[count.index]
  location = var.region
  count = length(var.cloud_storage_name)
}
