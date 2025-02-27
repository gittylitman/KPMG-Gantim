resource "google_storage_bucket" "storage_bucket" {
  name = var.name
  location = var.location
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "member" {
  bucket   = google_storage_bucket.storage_bucket.name
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}
