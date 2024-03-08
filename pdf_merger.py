import PyPDF2
from sys import argv
import os

merger = PyPDF2.PdfMerger()

PDF_name = argv[1]
PDF_dir = argv[2]

def merge():
    for file in os.listdir(PDF_dir):
        if file.endswith(".pdf"):
            file_path = os.path.join(PDF_dir, file)
            merger.append(file_path)
    output_path = os.path.join("/Users/serbanples/Desktop/files/documents", PDF_name + ".pdf")
    merger.write(output_path)

if __name__ == "__main__":
    merge()