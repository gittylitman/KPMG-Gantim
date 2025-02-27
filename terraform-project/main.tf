terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}
