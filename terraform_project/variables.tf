variable "cloud_storage_name" {
  type = list(string)
  default = [ "cloud-storage-admin", "cloud-storage-citizen" ]
}

variable "location" {
  default = "me-west1"
}