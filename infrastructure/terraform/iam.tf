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
  member  = "serviceAccount:terraform-etl@appspot.gserviceaccount.com"  
}

resource "google_cloudfunctions2_function_iam_member" "cloud_functions_admin" {
  project        = "terraform-etl"
  location       = "europe-west9"
  cloud_function = google_cloudfunctions2_function.function2.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_service_account" "test1" {
  account_id   = "terraform-etl"
  display_name = "Test Service Account"
}