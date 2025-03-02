variable "cloud_run_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_image" {
  type = string
}

variable "vpc_access_connector_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "connector_min_instances" {
  type = number
}

variable "connector_max_instances" {
  type = number
}

variable "dataset_id" {
  type = string
}

variable "role" {
  type = string
}
