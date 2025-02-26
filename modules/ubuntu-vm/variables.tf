variable "service_account_vm_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "machine_type" {
  type = string
  default = "e2-standard-4"
}

variable "zone" {
  type = string
}

variable "image" {
  type = string
  default = "Ubuntu 20.04 LTS"
}

variable "network" {
  type = string
}
