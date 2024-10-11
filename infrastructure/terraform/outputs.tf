#########################################
     # Import fichier par fichier #
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
   # Import de tous les fichiers csv #
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


#########################################
       # Pas ouf mais on garde #
#########################################

# Créer des "dossiers" dans le bucket en ajoutant des objets vides
# resource "google_storage_bucket_object" "medaillon_bronze" {
#   name    = "medaillon/bronze/csv/"  
#   bucket  = google_storage_bucket.my_bucket.name 
#   content = " "          
# }   
