variable "project_id" {
  type = string
}

# module network

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

# module cloud run

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

# module load_balancer

variable "neg_names" {
  type = list(string)
}

variable "backend_service_names" {
  type = list(string)
}

variable "lb_name" {
  type = string
}

variable "certificate_name" {
  type = string
}

variable "http_proxy_name" {
  type = string
}

variable "https_forwarding_rule_name" {
  type = string
}

variable "proxy_subnet_range" {
  type = string
}

variable "proxy_subnet_name" {
  type = string
}

variable "cert_file" {
  type = string
}

variable "private_key_file" {
  type = string
}

# module vm instance

variable "service_account_vm_name" {
  type = string
}

variable "zone_part" {
  type = string
}

variable "vm_name" {
  type = string
}

# module cloud storage

variable "cloud_storage_name" {
  type = list(string)
}
