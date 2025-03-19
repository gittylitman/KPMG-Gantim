resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
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
      ports {
        container_port = 80
      }
      image = var.container_image
    }
    
    vpc_access {
      network_interfaces {
        network = var.network_name
        subnetwork = var.subnetwork_name
        tags = []
      }
    }
    service_account = google_service_account.cloudrun_service_account.email
  }
  depends_on = [ google_bigquery_dataset_iam_member.bq_access ]
}

resource "google_bigquery_dataset_iam_member" "bq_access" {
  dataset_id = var.dataset_id
  role = "roles/${var.role}"
  member = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
  depends_on = [ google_service_account.cloudrun_service_account ]
}
