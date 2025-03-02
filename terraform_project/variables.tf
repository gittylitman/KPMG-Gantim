variable "project_id" {
  type = string
  default = "kpmg-gantim-452112"
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
  default = "10.1.0.0/24"
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

variable "role_connect_big_query" {
  type = string
  default = "bigquery.dataEditor"
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

variable "proxy_subnet_range" {
  type = string
  default = "10.2.0.0/26"
}

variable "cert_file" {
  type = string
  default = "./certificate.pem"
}

variable "private_key_file" {
  type = string
  default = "./private_key.pem"
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
        { name = "column1", type = "STRING", mode = "NULLABLE" },
        { name = "column2", type = "STRING", mode = "NULLABLE" }
      ]
    },
    {
      table_name = "table2"
      columns = [
        { name = "columnA", type = "STRING", mode = "NULLABLE" },
        { name = "columnB", type = "STRING", mode = "NULLABLE" }
      ]
    }
  ]
}
