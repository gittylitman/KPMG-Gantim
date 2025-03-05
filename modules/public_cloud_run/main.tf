
resource "google_vpc_access_connector" "connector" {
  name = var.public_vpc_access_connector_name
  region = var.location
  subnet {
    name = var.subnet_name
  }
  min_instances = var.connector_min_instances
  max_instances = var.connector_max_instances
}

resource "google_cloud_run_v2_service" "puclic_cloudrun" {
  name     = var.public_cloud_run_name
  location = var.location
  ingress = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    containers {
      image = var.public_container_image
    }

    vpc_access {
       connector = google_vpc_access_connector.connector.id
       egress = "ALL_TRAFFIC"
    }
  }
}


