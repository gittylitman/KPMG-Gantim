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

module "load_balancer" {
  source = "../modules/load_balancer"
  region = var.region
  neg_name = var.neg_names
  backend_service_name = var.backend_service_names
  vpc_name = module.network.network_name
  subnet_name = module.network.subnet_name
  lb_name = var.lb_name
  cloud_run_names = var.cloud_run_names
  certificate_name = var.certificate_name
  http_proxy_name = var.http_proxy_name
  https_forwarding_rule_name = var.https_forwarding_rule_name
  network_id = module.network.network_id
  ip_range = var.proxy_subnet_range
  subnet_private_name = var.proxy_subnet_name
  cert_file = var.cert_file
  private_key_file = var.private_key_file
  depends_on = [ module.cloud_run ]
}

module "ubuntu_vm_instance" {
  source = "../modules/ubuntu_vm"
  service_account_vm_name = var.service_account_vm_name
  zone = "${var.region}-${var.zone_part}"
  vm_name = var.vm_name
  network_name = module.network.network_name
  subnetwork_name = module.network.subnet_name
}

module "cloud_storage" {
  source = "../modules/cloud_storage"
  name = var.cloud_storage_name[count.index]
  location = var.region
  count = length(var.cloud_storage_name)
}
