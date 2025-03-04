terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state-binom"
  }
}

provider "google" {
  project = var.project_id
}


module "document"{
  source = "../modules/document_AI"
  location = var.location
  name = var.document_name
}

