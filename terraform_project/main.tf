terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state-binom"
  }
}

provider "google" {
  project = var.project_id
}

module "network" {
  source = "../modules/network"
  vpc_name = "${var.environment}-binom"
  subnetwork_name = "${var.project_name}-snet-${var.environment}-binom"
  region = var.region
  ip_cidr_range = var.ip_cidr_range
}

