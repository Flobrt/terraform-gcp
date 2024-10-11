#########################################
      # Fonction 1ere generation #
#########################################

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

#########################################
      # Fonction 2eme generation #
#########################################

resource "google_cloudfunctions2_function" "function2" {
  name        = "etl_terra"
  location    = "europe-west9" 
  
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
    ingress_settings   = "ALLOW_ALL"  
  }
}