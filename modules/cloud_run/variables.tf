variable "project_id" {
  type = string
}

variable "cloud_run_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_image" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "role" {
  type = string
  default = "bigquery.dataOwner"
}
