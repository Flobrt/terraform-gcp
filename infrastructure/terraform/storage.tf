resource "google_storage_bucket" "my_bucket" {
    name          = "my-bucket-2525"  
    location      = "EU"                  
    force_destroy = true                  

    uniform_bucket_level_access = true
}