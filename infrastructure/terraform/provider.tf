terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

variable "credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}

provider "google" {
  credentials = jsondecode(env("GCP_CREDENTIALS"))
}


# provider "google" {
#     project = "terraform-etl"
#     credentials = file("../data/credentials.json")
# }

resource "google_project_service" "run_api" {
  project = "terraform-etl"  # Remplace par ton ID de projet
  service = "run.googleapis.com"
}

