terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state-binom"
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}


module "document"{
  source = "../modules/document_AI"
  location = "EU"
  name = var.document_name
}
