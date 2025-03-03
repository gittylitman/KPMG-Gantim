variable "project_id" {
  type = string
  default = "kpmg-gantim-452112"
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

variable "region" {
  type = string
  default = "me-west1"
}

variable "ip_cidr_range" {
  type = string
  default = "100.69.3.0/28"
}

# module cloud run

variable "cloud_run_names" {
  type = list(string)
  default = ["crun-uploader", "crun-metrics"]
}

variable "container_image" {
  type = list(string)
  default = ["me-west1-docker.pkg.dev/dgt-gcp-pmo-nec-gnt-dev/nec-gnt-repo-dev/uploader:latest", "me-west1-docker.pkg.dev/dgt-gcp-pmo-nec-gnt-dev/nec-gnt-repo-dev/metrics:latest"]
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

variable "load_balancer_name" {
  type = list(string)
  default = ["uploader", "metrics"]
}

variable "proxy_subnet_range" {
  type = string
  default = "100.69.4.0/26"
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
  default = ["uploader", "metrics"]
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
