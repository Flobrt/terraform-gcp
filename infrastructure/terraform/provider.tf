terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

variable "credentials_file" {
  type = string
}

provider "google" {
    project = "terraform-etl"
    credentials = file(var.credentials_file)
}

resource "google_project_service" "run_api" {
  project = "terraform-etl"  # Remplace par ton ID de projet
  service = "run.googleapis.com"
}

