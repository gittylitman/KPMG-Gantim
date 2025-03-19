variable "project_id" {
  type = string
}

variable "host_project_id" {
  type = string
}

variable "project_name" {
  type = string
  default = "nec-gnt"
}

variable "environment" {
  type = string
  default = "dev"
}

# module network

variable "vpc_name" {
  type = string
  default = "dev"
}

variable "subnet_cloud_run_name" {
  type = string
}

variable "subnet_bigquery_name" {
  type = string
}

variable "region" {
  type = string
  default = "me-west1"
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
  default = [
    {
      table_name = "table1"
      columns = [
        { name = "columnA", type = "STRING", mode = "NULLABLE" },
        { name = "columnB", type = "STRING", mode = "NULLABLE" }
      ]
    }
  ]
}

# module cloud run

variable "cloud_run_names" {
  type = list(string)
  default = ["crun-uploader", "crun-metrics"]
}

variable "container_image" {
  type = list(string)
}

variable "access_connector_names" {
  type = list(string)
  default = [ "vpc-uploader", "vpc-metrics" ]
}

variable "connector_min_instances" {
  type = number
  default = 2
}

variable "connector_max_instances" {
  type = number
  default = 4
}

variable "role_connect_big_query" {
  type = string
  default = "bigquery.dataEditor"
}

# module front cloud run

variable "front_vpc_access_connector_name" {
  type = list(string)
  default = [ "vpc-fuploader", "vpc-fmetrics" ]
}

variable "front_cloud_run_name" {
  type = list(string)
  default = ["crun-front-uploader", "crun-front-metrics"]
}

variable "front_container_image" {
  type = list(string)
}

# module load balancer

variable "neg_name" {
  type = list(string)
  default = ["admin","metric"]
}

variable "backend_service_name" {
  type = list(string)
  default = ["admin","metric"]
}

variable "subnet_proxy_name" {
  type = string
}

variable "certificate_name" {
  type = string
}

# module vm instance

variable "zone_part" {
  type = string
  default = "a"
}
