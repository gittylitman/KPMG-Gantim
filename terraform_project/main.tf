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
  vpc_name = "${var.environment}-vpc-${var.region}"
  subnetwork_name = "${var.environment}-subnet-${var.region}"
  region = var.region
  ip_cidr_range = var.ip_cidr_range
}

module "cloud_run" {
  source = "../modules/cloud_run"
  cloud_run_name = "${var.environment}-cloudrun-${var.cloud_run_names[count.index]}-${var.region}"
  location = var.region
  container_image = var.container_image
  vpc_access_connector_name = "${var.environment}-accessconnector-${var.access_connector_names[count.index]}-${var.region}"
  subnet_name = module.network.subnet_name
  connector_min_instances = var.connector_min_instances
  connector_max_instances = var.connector_max_instances
  count = length(var.cloud_run_names)
}

module "load_balancer" {
  source = "../modules/load_balancer"
  region = var.region
  neg_name = "${var.environment}-neg-${var.neg_names[count.index]}-${var.region}"
  backend_service_name = "${var.environment}-backend-${var.backend_service_names[count.index]}-${var.region}"
  vpc_name = module.network.network_name
  subnet_name = module.network.subnet_name
  lb_name = "${var.environment}-lb-${var.region}"
  cloud_run_names = "${var.environment}-cloudrun-${var.cloud_run_names[count.index]}-${var.region}"
  certificate_name = "${var.environment}-certificate-${var.region}"
  http_proxy_name = "${var.environment}-httpproxy-${var.region}"
  https_forwarding_rule_name = "${var.environment}-httpsrule-${var.region}"
  network_id = module.network.network_id
  ip_range = var.proxy_subnet_range
  subnet_private_name = "${var.environment}-proxysubnet-${var.region}"
  cert_file = var.cert_file
  private_key_file = var.private_key_file
  depends_on = [ module.cloud_run ]
}

module "ubuntu_vm_instance" {
  source = "../modules/ubuntu_vm"
  service_account_vm_name = "${var.environment}-sa-vm-${var.region}"
  zone = "${var.region}-${var.zone_part}"
  vm_name = "${var.environment}-vm-${var.region}"
  network_name = module.network.network_name
  subnetwork_name = module.network.subnet_name
}

module "cloud_storage" {
  source = "../modules/cloud_storage"
  name = "${var.environment}-gcs-${var.cloud_storage_name[count.index]}-${var.region}"
  location = var.region
  count = length(var.cloud_storage_name)
}

module "bigquery" {
  source = "../modules/bigquery"
  dataset_id = "${var.environment}-dataset-${var.region}"
  location = var.region
  tables = var.tables
}
