variable "project_id" {
  type = string
}

variable location {
    default = "me-west1"
}
variable "cloud_run_name" {
  type = list(string)
  default = [ "gantim-cloudrun", "gantim-cloudrun-citizen" ]
}
variable "access_connector_name" {
  type = list(string)
  default = [ "access-connector-admin2", "access-connector-citizen2" ]
}

variable "region" {
  default = "me-west1"
}

variable "dataset_id"{
  type = string
  default = "gantim-dataset"
}

variable "role" {
  type = string
  default = "bigquery.dataViewer" 
}

variable "table" {
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