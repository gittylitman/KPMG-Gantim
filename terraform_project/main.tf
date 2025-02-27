terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}

module "cloud_storage" {
  source = "../modules/cloud_storage"
  name = var.cloud_storage_name[count.index]
  location = var.location
  count = length(var.cloud_storage_name)
}
