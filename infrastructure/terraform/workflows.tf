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