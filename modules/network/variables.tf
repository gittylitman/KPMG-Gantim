variable "vpc_name" {
  description = "Value of the VPC name"
  type = string
}

variable "subnetwork_name" {
  description = "Value of the subnetwork name"
  type = list(string)
}

variable "region" {
  description = "Name of region"
  type = string
}

variable "ip_cidr_range" {
  description = "subnet ip"
  type        = list(string)
}
