terraform {
  backend "gcs" {
    bucket  = "nec-gcs-gnt-dev"
    prefix  = "state"
  }
}

provider "google" {
  project = var.project_id
}

resource "google_project_service" "cloudresourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

module "network" {
  source = "../modules/network"
  host_project_id = var.host_project_id
  vpc_name = var.vpc_name
  subnetwork_names = [var.subnet_cloud_run_name]
  region = var.region
  depends_on = [ google_project_service.cloudresourcemanager ]
}

module "bigquery" {
  source = "../modules/bigquery"
  dataset_id = "${replace(var.project_name, "-", "_")}_bgquery_${var.environment}"
  location = var.region
  tables = var.tables
  depends_on = [ google_project_service.cloudresourcemanager ]
}

module "cloud_run" {
  source = "../modules/cloud_run"
  cloud_run_name = "${var.project_name}-${var.cloud_run_names[count.index]}-${var.environment}"
  location = var.region
  container_image = var.container_image[count.index]
  service_account_name = "${var.environment}-sa-${var.cloud_run_names[count.index]}"
  dataset_id = module.bigquery.dataset_id
  role = var.role_connect_big_query
  network_name = module.network.network_id
  subnetwork_name = module.network.subnet_id
  count = length(var.cloud_run_names)
  depends_on = [ 
    google_project_service.cloudresourcemanager,
    module.bigquery
  ]
}

module "front_cloud_run" {
  source = "../modules/front_cloud_run"
  location = var.region
  front_cloud_run_name =  "${var.project_name}-${var.front_cloud_run_name[count.index]}-${var.environment}"
  front_container_image = var.front_container_image[count.index]
  network_name = module.network.network_id
  subnetwork_name = module.network.subnet_id
  count = length(var.front_cloud_run_name)
  depends_on = [ google_project_service.cloudresourcemanager ]
}

module "load_balancer" {
  source = "../modules/load_balancer"
  region = var.region
  neg_name = ["${var.project_name}-neg-${var.neg_name[0]}-${var.environment}","${var.project_name}-neg-${var.neg_name[1]}-${var.environment}"]
  backend_service_name =["${var.project_name}-bsrv-${var.backend_service_name[0]}-${var.environment}","${var.project_name}-bsrv-${var.backend_service_name[1]}-${var.environment}"]
  vpc_name = module.network.network_id
  subnet_name = var.subnet_proxy_name
  lb_name = "${var.project_name}-ilb-${var.environment}"
  cloud_run_name = ["${var.project_name}-${var.front_cloud_run_name[0]}-${var.environment}","${var.project_name}-${var.front_cloud_run_name[1]}-${var.environment}"]
  certificate_name = var.certificate_name
  http_proxy_name = "${var.project_name}-server-prxy-${var.environment}"
  https_forwarding_rule_name = "${var.project_name}-server-prxy-fwrule-${var.environment}"
  subnet_private_name = module.network.subnet_id
  host_project_id = var.host_project_id
  depends_on = [ 
    google_project_service.cloudresourcemanager,
    module.front_cloud_run
  ]
}

module "ubuntu_vm_instance" {
  source = "../modules/ubuntu_vm"
  service_account_vm_name = "${var.project_name}-ubut-sa-vm-${var.environment}"
  zone = "${var.region}-${var.zone_part}"
  vm_name = "${var.project_name}-ubut-vm-${var.environment}"
  network_name = module.network.network_id
  subnetwork_name = module.network.subnet_id
  depends_on = [ google_project_service.cloudresourcemanager ]
}
