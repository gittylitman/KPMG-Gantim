terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}

module "network" {
  source = "../modules/network"

  vpc_name = "gantim"
  subnetwork_name = "snet-gantim"
  region = var.location
  ip_cidr_range = "10.1.0.0/28"

}

module "backend_service" {
  source = "../modules/load-balancer"

  region = var.location
  vpc_name = module.network.network_name
  subnet_name = module.network.subnet_name
}
