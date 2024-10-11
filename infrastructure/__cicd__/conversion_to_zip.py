import io
import zipfile
from google.cloud import storage
import os

def get_all_folder(path_to_folder, project_id = None, bucket_name = None):
    ###### Google Cloud Storage ######
    # # Connect to Google Cloud Storage
    # storage_client = storage.Client(project=project_id)
    # bucket = storage_client.get_bucket(bucket_name)
    # blobs = bucket.list_blobs(prefix=path_to_folder)

    # list_folder = []
    # # Get list of files
    # for i in blobs:
    #     if i.name.endswith('unzip/'):
    #         list_folder.append(i.name)
    # return list_folder, bucket

    ###### Local ######
    list_folder = []
    for root, _, _ in os.walk(path_to_folder):
        if root.endswith('/unzip'):
            list_folder.append(root)

    return list_folder

def zip_folder(list_folder, bucket = None):
    ############## Google Cloud Storage ##############
    # for file in list_folder:
    #     try: 
    #         nom_state = file.split('/')[-2]

    #         file_zip = file.replace('unzip/', 'zip/') + f'{nom_state}.zip'

    #         # Obtenir le blob (fichier) dans le bucket
    #         blobs = bucket.blob(file_zip)

    #         # Vérifier si le blob existe
    #         if not blobs.exists():
    #             blobs.upload_from_string("")  # Crée un fichier vide
    #             print(f"Folder {file_zip} created")
    #         else:
    #             print(f"Folder {file_zip} already exists")

    #         try:
    #             # Remplacer 'unzip/' par 'zip/' pour créer le chemin du fichier zip
    #             zip_file_path = file.replace('unzip/', 'zip/') + f'{nom_state}.zip'

    #             # Obtenir les blobs dans le dossier "unzip/"
    #             blobs = list(bucket.list_blobs(prefix=file))  # Convertir en liste

    #             # Si aucun fichier n'est présent dans le dossier, continuer
    #             if not blobs:
    #                 print(f"No files found in file {file}. Skipping...")
    #                 continue

    #             # Créer un buffer en mémoire pour le fichier zip
    #             zip_buffer = io.BytesIO()

    #             # Créer un fichier zip en mémoire
    #             with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
    #                 for blob in blobs:
    #                     # Exclure les dossiers, on ne zippe que les fichiers
    #                     if not blob.name.endswith('/'):
    #                         # Télécharger le fichier dans la mémoire
    #                         file_data = blob.download_as_bytes()
    #                         # Ajouter le fichier dans le fichier zip
    #                         zip_file.writestr(blob.name.split('/')[-1], file_data)

    #             # Réinitialiser le pointeur du buffer au début
    #             zip_buffer.seek(0)

    #             # Créer un nouvel objet Blob pour le fichier zip dans le chemin 'zip/'
    #             zip_blob = bucket.blob(zip_file_path)

    #             # Télécharger le fichier zip dans le bucket
    #             zip_blob.upload_from_file(zip_buffer, content_type='application/zip')
    #             print(f"file {file} zipped and uploaded as {zip_file_path}")
        
    #         except Exception as e:
    #             print(f"Error in zipping file {file}: {e}")
        
    #     except Exception as e:
    #         print(f"Error in file {file}: {e}")

    ################### Local ###################
    for folder in list_folder:
        try:
            # Extraire le nom du dossier pour nommer le fichier zip
            nom_state = folder.split(os.sep)[-2]  # Utiliser os.sep pour chemin local

            # Créer le chemin du fichier zip dans le dossier "zip/"
            zip_file_path = folder.replace('unzip', 'zip') + f'/{nom_state}.zip'
        
            # Créer le répertoire "zip/" s'il n'existe pas
            os.makedirs(os.path.dirname(zip_file_path), exist_ok=True)

            # Lister tous les fichiers dans le dossier "unzip/"
            files_to_zip = []
            for root, _, files in os.walk(folder):
                for file in files:
                    file_path = os.path.join(root, file)
                    files_to_zip.append(file_path)

            # Si aucun fichier n'est présent, passer au dossier suivant
            if not files_to_zip:
                print(f"No files found in folder {folder}. Skipping...")
                continue

            # Créer un fichier zip localement
            with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zip_file:
                for file_path in files_to_zip:
                    # Ajouter chaque fichier dans le zip avec son chemin relatif
                    relative_path = os.path.relpath(file_path, folder)
                    zip_file.write(file_path, arcname=relative_path)

            print(f"Folder {folder} zipped and saved as {zip_file_path}")
        
        except Exception as e:
            print(f"Error in zipping folder {folder}: {e}")



def main():
    ############ Google Cloud Storage ############
    # # ID de projet et nom du bucket
    # project_id = "terraform-etl "
    # bucket_name = "etl-terraform-2563"
    # path_to_folder_csv = "code/"
    ##############################################

    ############ Local ############
    path_to_folder_csv = "/home/florian/code/brief-terraform/data-services"

    list_folder = get_all_folder(path_to_folder=path_to_folder_csv)
    zip_folder(list_folder)

    # return "Conversion to Zip completed", 200

if __name__ == "__main__":
    main()