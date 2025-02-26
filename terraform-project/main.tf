terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}


module "network" {
  source = "../modules/network"
  vpc_name = "gantim-network"
  subnetwork_name = "snet-gantim"
  region = "me-west1"
  ip_cidr_range = "10.1.0.0/24"
}
