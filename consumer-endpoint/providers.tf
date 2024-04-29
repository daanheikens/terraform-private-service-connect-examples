terraform {
  required_version = "~>1.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.26"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~>5.26"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
