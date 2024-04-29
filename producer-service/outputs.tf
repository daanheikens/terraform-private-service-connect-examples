# Use this value for the consumer as a target reference
output "service_attachment_id" {
  value = google_compute_service_attachment.apache_web_server.id
}
