variable "dataset_id" {
  type = string
}

variable "location" {
  type = string
}

variable "role" {
  type = string
}

variable "cloud_run_service_account" {
  type = string
}

variable "tables" {
  type = list(object({
    table_name = string
    columns     = list(object({
      name   = string
      type   = string
      mode   = string
    }))
  }))
}