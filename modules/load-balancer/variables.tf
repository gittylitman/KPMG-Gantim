variable "region" {
  type = string
}

variable "neg_name" {
  type = list(string)
  default = [ "cloud-run-admin-neg", "cloud-run-citizen-neg" ]
}

variable "backend_service_name" {
  type = list(string)
  default = [ "internal-backend-service-admin", "internal-backend-service-citizen" ]
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "cloud_run_name" {
  type = list(string)
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

variable "network_id" {
  type = string
}

variable "ip_range" {
  type = string
}

variable "subnet_private_name" {
  type = string
}

variable "cert_file" {
  type = string
}

variable "private_key_file" {
  type = string
}