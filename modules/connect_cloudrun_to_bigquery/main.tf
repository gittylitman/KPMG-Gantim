resource "google_bigquery_dataset_iam_member" "bq_access" {
  dataset_id = var.dataset_id
  role = "roles/${var.role}"
  member = "serviceAccount:${var.cloud_run_service_account}"
}