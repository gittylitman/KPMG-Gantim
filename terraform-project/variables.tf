variable location {
    default = "me-west1"
}

variable "cloud_run_name" {
  type = list(string)
  default = [ "gantim-admin", "gantim-citizen" ]
}

variable "access_connector_name" {
  type = list(string)
  default = [ "access-connector-admin-1", "access-connector-citizen-1" ]
}