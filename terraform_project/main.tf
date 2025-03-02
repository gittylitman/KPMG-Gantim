terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state/bigquery"
  }
}

provider "google" {
  project = var.project_id
}

module "network" {
  source = "../modules/network"
  vpc_name = "gantim2"
  subnetwork_name = "snet-gantim2"
  region = var.location
  ip_cidr_range = "10.2.0.0/28"
}
module "cloud_run" {
  source = "../modules/cloud-run"
  cloud_run_name = var.cloud_run_name[count.index]
  location = var.location
  container_image = "us-docker.pkg.dev/cloudrun/container/hello"
  vpc_access_connector_name = var.access_connector_name[count.index]
  subnet_name = module.network.subnet_name
  connector_min_instances = 2
  connector_max_instances = 4
  count = length(var.cloud_run_name)
}

module "bigquery" {
  source = "../modules/bigquery"
  dataset_id = var.dataset_id
  location = var.location
  tables = var.table
}

module "connect_cloud_run"{
  source = "../modules/connect_cloud_run_to_bigquery"
  dataset_id = module.bigquery.dataset_id
  role = var.role
  cloud_run_service_account = module.cloud_run[count.index].uri
  count = length(var.cloud_run_name)
}