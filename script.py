# Supprimer tous les fichiers qui se termine par .Zone.Identifier
import os
import sys

def main():
    path = "/home/florian/code/terraform-gcp/"
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith("Zone.Identifier"):
                
                os.remove(os.path.join(root, file))

if __name__ == "__main__":
    main()