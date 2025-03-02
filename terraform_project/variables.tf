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

variable "cloud_storage_name" {
  type = list(string)
}
