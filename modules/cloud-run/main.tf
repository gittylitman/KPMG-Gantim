resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_v2_service" "cloud_run"{
  name = var.cloud_run_name
  location = var.location
  deletion_protection = false
  template {
    containers {
      image = var.container_image
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress = "ALL_TRAFFIC"
    }
  }
}

resource "google_vpc_access_connector" "connector" {
  name = var.vpc_access_connector_name
  region = var.location
  subnet {
    name = var.subnet_name
  }
  depends_on = [ google_project_service.vpcaccess ]
}
