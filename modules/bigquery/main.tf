resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id                  = var.dataset_id
  location                    = var.location
}

resource "google_bigquery_table" "bigquery_table" {
  count = length(var.tables)
  dataset_id = google_bigquery_dataset.bigquery_dataset.dataset_id
  table_id   = var.tables[count.index].table_name
  deletion_protection = false
  schema = jsonencode([
    for col in var.tables[count.index].columns : {
      name = col.name
      type = col.type
      mode = col.mode
    }
  ])
}

resource "google_bigquery_dataset_iam_member" "bq_access" {
  dataset_id = google_bigquery_dataset.bigquery_dataset.dataset_id
  role       = "roles/${var.role}"
  member     = "serviceAccount:${var.cloud_run_service_account}"
  # count = length(var.cloud_run_service_account)
}
