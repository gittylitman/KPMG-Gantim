resource "google_project_service" "bigquery" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id                  = var.dataset_id
  location                    = var.location
  depends_on = [ google_project_service.bigquery ]
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