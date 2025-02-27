terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state/vm"
  }
}

module "network" {
  source = "../modules/network"
  vpc_name = "gantim-network"
  subnetwork_name = "gantim-subnetwork"
  region = var.region
  ip_cidr_range = "10.2.0.0/28"
}

module "ubuntu_vm" {
  source = "../modules/ubuntu_vm"
  service_account_vm_name = "gantim-sa-vm"
  zone = "${var.region}-b"
  vm_name = "gantim-vm"
  network_name = module.network.network_name
  subnetwork_name = module.network.subnet_name
}
