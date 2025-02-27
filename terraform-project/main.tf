terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state/bigquery"
  }
}

module "bigquery" {
  source = "../modules/bigquery"
  dataset_id = "try-my-dataset"
  location = "me-west-1"
  role = "BigQuery Data Editor"
  service_account_vm_name = "try-serviceaccount-vm"
  tables = [
    {
      table_name = "first_table"
      columns = [
        {
          name = "id"
          type = "STRING"
          mode = "REQUIRED"
        },
        {
          name = "created_at"
          type = "TIMESTAMP"
          mode = "NULLABLE"
        }
      ]
    },
    {
      table_name = "second_table"
      columns = [
        {
          name = "user_id"
          type = "STRING"
          mode = "REQUIRED"
        },
        {
          name = "score"
          type = "INTEGER"
          mode = "NULLABLE"
        }
      ]
    }
  ]
}
