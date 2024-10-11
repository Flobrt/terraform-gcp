import pandas as pd
import functions_framework
from google.cloud import storage


def get_list_files(project_id, bucket_name, path_to_folder):
    # Connect to Google Cloud Storage
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.get_bucket(bucket_name)
    blobs = bucket.list_blobs(prefix=path_to_folder)

    # Get list of files
    list_files = []
    for blob in blobs:
        name = blob.name.split("/")[-1][:-4]
        if name != "":
            list_files.append(name)
    return list_files

def convert_csv_to_parquet(bucket_name, path_to_folder_csv, path_to_folder_parquet, list_files):
   
    for file in list_files:
        try:
            # Folders
            path_from_csv = f"gs://{bucket_name}/{path_to_folder_csv}/{file}.csv"
            path_to_parquet = f"gs://{bucket_name}/{path_to_folder_parquet}/{file}.parquet"
            
            # Read CSV and save as Parquet
            df = pd.read_csv(path_from_csv)
            df.to_parquet(path=path_to_parquet)

            print(f"File {file} converted to Parquet")
        
        except Exception as e:
            print(f"Error in file {file}: {e}")

@functions_framework.http
def main(request):
    # ID de projet et nom du bucket
    project_id = "terraform-etl "
    bucket_name = "my-bucket-2525"
    path_to_folder_csv = "medaillon/bronze/csv"
    path_to_folder_parquet = "medaillon/bronze/parquet"

    list_files = get_list_files(project_id, bucket_name, path_to_folder_csv)
    convert_csv_to_parquet(bucket_name, path_to_folder_csv, path_to_folder_parquet, list_files)

    return "Conversion to Parquet completed", 200

# if __name__ == "__main__":
#     main()