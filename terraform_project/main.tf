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
  subnetwork_name = ["${var.project_name}-snet-${var.environment}", "${var.project_name}-snet2-${var.environment}"]
  region = var.region
  ip_cidr_range = var.ip_cidr_range
  host_project_id = var.host_project_id
}

module "bigquery" {
  source = "../modules/bigquery"
  dataset_id = "${replace(var.project_name, "-", "_")}_bgquery_${var.environment}"
  location = var.region
  tables = var.tables
}

module "cloud_run" {
  source = "../modules/cloud_run"
  cloud_run_name = "${var.project_name}-${var.cloud_run_names[count.index]}-${var.environment}"
  location = var.region
  container_image = var.container_image[count.index]
  vpc_access_connector_name = "${var.project_name}-${var.access_connector_names[count.index]}-${var.environment}"
  subnet_name = module.network.subnet_name
  service_account_name = "${var.environment}-sa-${var.cloud_run_names[count.index]}"
  connector_min_instances = var.connector_min_instances
  connector_max_instances = var.connector_max_instances
  dataset_id = module.bigquery.dataset_id
  role = var.role_connect_big_query
  count = length(var.cloud_run_names)
  depends_on = [ module.bigquery ]
}

module "front_cloud_run" {
  source = "../modules/front_cloud_run"
  front_vpc_access_connector_name = "${var.project_name}-${var.front_vpc_access_connector_name[count.index]}-${var.environment}"
  location = var.region
  subnet_name = module.network.subnet_name
  connector_min_instances = var.connector_min_instances
  connector_max_instances = var.connector_max_instances
  front_cloud_run_name =  "${var.project_name}-${var.front_cloud_run_name[count.index]}-${var.environment}"
  front_container_image = var.front_container_image[count.index]
  count = length(var.front_cloud_run_name)
}

module "load_balancer" {
  source = "../modules/load_balancer"
  region = var.region
  neg_name = ["${var.project_name}-neg-${var.neg_name[0]}-${var.environment}","${var.project_name}-neg-${var.neg_name[1]}-${var.environment}"]
  backend_service_name =["${var.project_name}-bsrv-${var.backend_service_name[0]}-${var.environment}","${var.project_name}-bsrv-${var.backend_service_name[1]}-${var.environment}"]
  vpc_name = module.network.network_name
  subnet_name = "${var.project_name}-snet-prxy-${var.environment}"
  lb_name = "${var.project_name}-ilb-${var.environment}"
  cloud_run_name = ["${var.project_name}-${var.front_cloud_run_name[0]}-${var.environment}","${var.project_name}-${var.front_cloud_run_name[1]}-${var.environment}"]
  certificate_name = "${var.project_name}-cert-${var.environment}"
  http_proxy_name = "${var.project_name}-server-prxy-${var.environment}"
  https_forwarding_rule_name = "${var.project_name}-server-prxy-fwrule-${var.environment}"
  network_id = module.network.network_id
  ip_range = var.proxy_subnet_range
  subnet_private_name = module.network.subnet_name
  cert_file = var.cert_file
  private_key_file = var.private_key_file
  host_project_id = var.host_project_id
  depends_on = [ module.front_cloud_run ]
}

module "ubuntu_vm_instance" {
  source = "../modules/ubuntu_vm"
  service_account_vm_name = "${var.project_name}-ubut-sa-vm-${var.environment}"
  zone = "${var.region}-${var.zone_part}"
  vm_name = "${var.project_name}-ubut-vm-${var.environment}"
  network_name = module.network.network_name
  subnetwork_name = module.network.subnet_name
}
