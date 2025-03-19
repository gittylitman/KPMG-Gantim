variable "region" {
  type = string
}

variable "neg_name" {
  type = list(string)
}

variable "backend_service_name" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "lb_name" {
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

variable "subnet_private_name" {
  type = string
}

variable "host_project_id" {
  type = string
}
