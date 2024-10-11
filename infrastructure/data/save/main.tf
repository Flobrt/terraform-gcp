terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

resource "google_project_service" "run_api" {
  project = "terraform-etl"  # Remplace par ton ID de projet
  service = "run.googleapis.com"
}

provider "google" {
    project = "terraform-etl"
}

resource "google_project_iam_member" "run_admin" {
  project = "terraform-etl"
  role    = "roles/run.admin"
  member  = "serviceAccount:terraform-etl@appspot.gserviceaccount.com"  # Remplace par l'adresse email de ton compte de service
}

resource "google_project_iam_member" "cloud_functions_developer" {
  project = "terraform-etl"
  role    = "roles/cloudfunctions.developer"
  member  = "serviceAccount:terraform-etl@appspot.gserviceaccount.com"  # Remplace par l'adresse email de ton compte de service
}

resource "google_project_iam_member" "service_account_user" {
  project = "terraform-etl"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:terraform-etl@appspot.gserviceaccount.com"  # Remplace par l'adresse email de ton compte de service
}

resource "google_storage_bucket" "my_bucket" {
    name          = "my-bucket-2525"  
    location      = "EU"                  
    force_destroy = true                  

    uniform_bucket_level_access = true
}


# Créer des "dossiers" dans le bucket en ajoutant des objets vides
# resource "google_storage_bucket_object" "medaillon_bronze" {
#   name    = "medaillon/bronze/csv/"  
#   bucket  = google_storage_bucket.my_bucket.name 
#   content = " "          
# }   

# Upload a text file as an object
# to the storage bucket

#################################################################################################################################################
#################################################################################################################################################
#################################################################################################################################################
#################################################################################################################################################

#########################################
# Import fichier par fichier
#########################################

# resource "google_storage_bucket_object" "clients" {
#     name         = "medaillon/bronze/csv/clients.csv"
#     source       = "/home/florian/code/brief-terraform/infrastructure/data/csv/clients.csv"
#     content_type = "text/plain"
#     bucket       = google_storage_bucket.my_bucket.id
# }       

# resource "google_storage_bucket_object" "produits" {
#     name         = "medaillon/bronze/csv/produits.csv"
#     source       = "/home/florian/code/brief-terraform/infrastructure/data/csv/produits.csv"
#     content_type = "text/plain"
#     bucket       = google_storage_bucket.my_bucket.id
# }  

# resource "google_storage_bucket_object" "stocks" {
#     name         = "medaillon/bronze/csv/stocks.csv"
#     source       = "/home/florian/code/brief-terraform/infrastructure/data/csv/stocks.csv"
#     content_type = "text/plain"
#     bucket       = google_storage_bucket.my_bucket.id
# }  

# resource "google_storage_bucket_object" "ventes" {
#     name         = "medaillon/bronze/csv/ventes.csv"
#     source       = "/home/florian/code/brief-terraform/infrastructure/data/csv/ventes.csv"
#     content_type = "text/plain"
#     bucket       = google_storage_bucket.my_bucket.id
# }  

#########################################
# Import de tous les fichiers csv 
#########################################

resource "google_storage_bucket_object" "zip_bronze" {
    name         = "code/bronze/zip/ingestion.zip"
    source       = "/home/florian/code/brief-terraform/data-services/ingestion/zip/ingestion.zip"
    content_type = "text/plain"
    bucket       = google_storage_bucket.my_bucket.id
}

resource "null_resource" "upload_folder" {
  provisioner "local-exec" {
    command = "gsutil cp -r /home/florian/code/brief-terraform/infrastructure/data/csv gs://${google_storage_bucket.my_bucket.name}/medaillon/bronze/csv"
  }

  depends_on = [google_storage_bucket.my_bucket]
}

#resource "google_cloudfunctions2_function" "function" {
#  name        = "function-bronze"
#  description = "My function"
#  runtime     = "python39"
#  region      = "europe-west1"

#  available_memory_mb   = 128
#  source_archive_bucket = google_storage_bucket.my_bucket.name
#  source_archive_object = google_storage_bucket_object.zip_bronze.name
#  trigger_http          = true
#  entry_point           = "main"
#}

resource "google_cloudfunctions2_function" "function2" {
  name        = "etl_terra"
  location    = "europe-west9" # This is where you set the region.
  
  build_config {
    runtime = "python39"
    entry_point          = "main"
    source {
      storage_source {
        bucket = google_storage_bucket.my_bucket.name
        object = google_storage_bucket_object.zip_bronze.name
      }
    }
  }

  service_config {
    max_instance_count = 2
    ingress_settings   = "ALLOW_ALL"  # Permet l'accès HTTP externe
  }
}
  
 
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = "terraform-etl"
  location       = "europe-west9"
  cloud_function = google_cloudfunctions2_function.function2.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

#################################################################################################################################################
#################################################################################################################################################
#################################################################################################################################################
#################################################################################################################################################

resource "google_service_account" "test1" {
  account_id   = "terraform-etl"
  display_name = "Test Service Account"
}

resource "google_workflows_workflow" "workflow" {
  name          = "workflow"
  region        = "europe-west9"
  description   = "Magic"
  service_account = "terraform-etl@appspot.gserviceaccount.com"
  labels = {
    env = "test"
  }
  source_contents = <<-EOT
  main:
    steps:
    - callFunction:
        call: http.get
        args:
          url:  "${google_cloudfunctions2_function.function2.service_config[0].uri}" 
          auth:
            type: OIDC
    - logResult:
        return: "Cloud Function exécutée avec succès"
  EOT
}

