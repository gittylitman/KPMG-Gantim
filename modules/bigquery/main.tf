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

resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "vm_instance_service_account" {
  account_id   = var.service_account_vm_name
  display_name = "Custom SA for VM Instance"
  depends_on = [ google_project_service.iam ]
}


resource "google_bigquery_dataset_iam_member" "bq_access" {
  dataset_id = google_bigquery_dataset.bigquery_dataset.dataset_id
  role       = "roles/${var.role}"
  member     = "serviceAccount:${google_service_account.vm_instance_service_account.email}"
}
