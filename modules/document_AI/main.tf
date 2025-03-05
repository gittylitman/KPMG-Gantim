
resource "google_document_ai_processor" "processor" {
  location = var.location
  display_name = var.name
  type = "OCR_PROCESSOR"
}
# DOCUMENT_TEXT_DETECTION
  # type = "DOCUMENT_PROCESSOR"

output "processor_id" {
  value = google_document_ai_processor.processor.id
}