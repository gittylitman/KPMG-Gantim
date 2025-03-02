variable "project_id" {
  type = string
  default = "gantim-dev"
}

variable "project_name" {
  type = string
  default = "gantim"
}

variable "environment" {
  type = string
  default = "dev"
}

# module network

variable "region" {
  type = string
  default = "me-west1"
}

variable "ip_cidr_range" {
  type = string
  description = "ip range for subnet - /28"
  default = "10.1.0.0/28"
}

# module cloud run

variable "cloud_run_names" {
  type = list(string)
  default = ["admin", "citizen"]
}

variable "container_image" {
  type = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "access_connector_names" {
  type = list(string)
  default = [ "admin", "citizen" ]
}

variable "connector_min_instances" {
  type = number
  default = 2
}

variable "connector_max_instances" {
  type = number
  default = 4
}

# module load_balancer

variable "neg_names" {
  type = list(string)
  default = ["admin", "citizen"]
}

variable "backend_service_names" {
  type = list(string)
  default = ["admin", "citizen"]
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

variable "zone_part" {
  type = string
  default = "a"
}

# module cloud storage

variable "cloud_storage_name" {
  type = list(string)
  default = ["admin", "citizen"]
}
