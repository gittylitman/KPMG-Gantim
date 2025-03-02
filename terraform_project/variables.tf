variable "project_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "region" {
  type = string
  default = "me-west1"
}

variable "ip_cidr_range" {
  type = string
  description = "ip range for subnet - /28"
}

variable "cloud_run_names" {
  type = list(string)
}

variable "container_image" {
  type = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "access_connector_names" {
  type = list(string)
}

variable "connector_min_instances" {
  type = number
}

variable "connector_max_instances" {
  type = number
}

variable "cloud_storage_name" {
  type = list(string)
}
