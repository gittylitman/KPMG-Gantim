variable "project_id" {
  type = string
  default = "project-management-459011"
}

variable "host_project_id" {
  type = string
  default = "project-management-459011"
}

variable "project_name" {
  type = string
  default = "nec-gnt"
}

variable "environment" {
  type = string
  default = "try"
}

# module network

variable "vpc_name" {
  type = string
  default = "dev"
}

variable "subnet_cloud_run_names" {
  type = list(string)
  default = [ "neg-gnt-compute-back-snet" , "neg-gnt-compute-front-snet" ]
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
  default = ["us-docker.pkg.dev/cloudrun/container/hello", "us-docker.pkg.dev/cloudrun/container/hello"]
}

# module front cloud run

variable "front_cloud_run_name" {
  type = list(string)
  default = ["crun-front-uploader", "crun-front-metrics"]
}

variable "front_container_image" {
  type = list(string)
  default = ["us-docker.pkg.dev/cloudrun/container/hello", "us-docker.pkg.dev/cloudrun/container/hello"]
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
