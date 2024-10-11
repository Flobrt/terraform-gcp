terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

provider "google" {
    project = "terraform-etl"
}

resource "google_project_service" "run_api" {
  project = "terraform-etl"  # Remplace par ton ID de projet
  service = "run.googleapis.com"
}