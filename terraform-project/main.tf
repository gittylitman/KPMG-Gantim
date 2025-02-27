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
  tables = <<EOF
[
  {
    "name": "permalink",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The Permalink"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State where the head office is located"
  }
]
EOF
}
