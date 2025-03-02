variable "dataset_id" {
  type = string
}

variable "location" {
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