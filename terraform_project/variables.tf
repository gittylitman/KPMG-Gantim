variable "project_id" {
  type = string
}

variable "host_project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# module network

variable "vpc_name" {
  type = string
}

variable "subnet_cloud_run_names" {
  type = list(string)
  default = [ "neg-gnt-compute-back-snet" , "neg-gnt-compute-front-snet" ]
}

variable "region" {
  type = string
}

# module bigquery

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

# module cloud run

variable "cloud_run_names" {
  type = list(string)
}

variable "container_image" {
  type = list(string)
}

# module front cloud run

variable "front_cloud_run_name" {
  type = list(string)
}

variable "front_container_image" {
  type = list(string)
}

# module load balancer

variable "neg_name" {
  type = list(string)
}

variable "backend_service_name" {
  type = list(string)
}
