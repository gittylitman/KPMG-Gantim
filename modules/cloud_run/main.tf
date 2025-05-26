resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "cloudrun_service_account" {
  account_id = var.service_account_name
}

resource "google_project_iam_member" "bigquery_access" {
  project = var.project_id
  role    = "roles/${var.role}"
  member  = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
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
      network_interfaces {
        network = module.network.network_name
        subnetwork = module.network.subnetworks_names[0].name
        tags = []
      }
    }
    service_account = google_service_account.cloudrun_service_account.email
  }
  depends_on = [ 
    google_project_service.run,
    google_project_service.vpcaccess,
 ]
}
