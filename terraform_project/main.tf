terraform {
  backend "gcs" {
    bucket  = "nec-gcs-gnt-dev2"
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

resource "google_project_service" "serviceusage" {
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
  depends_on = [ google_project_service.cloudresourcemanager ]
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "iam" {
  project = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
  depends_on = [ google_project_service.serviceusage ]
}

resource "google_project_iam_binding" "project" {
  project = var.host_project_id
  role = "roles/compute.networkUser"
  members = [
      "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com",
  ]
}

module "network" {
  source = "../modules/network"
  host_project_id = var.host_project_id
  vpc_name = var.vpc_name
  subnetwork_names = var.subnet_cloud_run_name
  region = var.region
  depends_on = [ google_project_service.serviceusage]         
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
  project_id = var.project_id
  cloud_run_name = "${var.project_name}-${var.cloud_run_names[count.index]}-${var.environment}"
  location = var.region
  container_image = var.container_image[count.index]
  service_account_name = "${var.environment}-sa-${var.cloud_run_names[count.index]}"
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
  count = length(var.front_cloud_run_name)
  depends_on = [ google_project_service.cloudresourcemanager ]
}

module "load_balancer" {
  source = "../modules/load_balancer"
  region = var.region
  neg_name = ["${var.project_name}-neg-${var.neg_name[0]}-${var.environment}","${var.project_name}-neg-${var.neg_name[1]}-${var.environment}"]
  backend_service_name =["${var.project_name}-bsrv-${var.backend_service_name[0]}-${var.environment}","${var.project_name}-bsrv-${var.backend_service_name[1]}-${var.environment}"]
  lb_name = "${var.project_name}-ilb-${var.environment}"
  cloud_run_name = ["${var.project_name}-${var.front_cloud_run_name[0]}-${var.environment}","${var.project_name}-${var.front_cloud_run_name[1]}-${var.environment}"]
  http_proxy_name = "${var.project_name}-server-prxy-${var.environment}"
  https_forwarding_rule_name = "${var.project_name}-server-prxy-fwrule-${var.environment}"
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
  depends_on = [ google_project_service.cloudresourcemanager ]
}
