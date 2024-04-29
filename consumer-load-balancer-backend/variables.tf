variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Used region for regional resources"
}

variable "service_attachment_id" {
  type        = string
  description = "Service Attachment ID of the published service."
}
