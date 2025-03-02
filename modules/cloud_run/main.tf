resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_vpc_access_connector" "connector" {
  name = var.vpc_access_connector_name
  region = var.location
  subnet {
    name = var.subnet_name
  }
  min_instances = var.connector_min_instances
  max_instances = var.connector_max_instances
  depends_on = [ google_project_service.vpcaccess ]
}

resource "google_service_account" "cloudrun_service_account" {
  account_id = var.service_account_name
}

resource "google_cloud_run_v2_service" "cloud_run"{
  name = var.cloud_run_name
  location = var.location
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false
  template {
    containers {
      image = var.container_image
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress = "ALL_TRAFFIC"
    }
    service_account = google_service_account.cloudrun_service_account.id
  }
}

resource "google_bigquery_dataset_iam_member" "bq_access" {
  dataset_id = var.dataset_id
  role = "roles/${var.role}"
  member = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
}
