variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Used region for regional resources"
}

variable "accepted_consumers" {
  type = list(object({
    connection_limit: number
    project_number: number
  }))
  description = "List of consumers which are eligible to connect to the published PSC service"
}