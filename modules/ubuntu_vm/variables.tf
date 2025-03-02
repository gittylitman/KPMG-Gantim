variable "service_account_vm_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

variable "machine_type" {
  type = string
  default = "e2-standard-4"
}

variable "image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}
