#!/usr/bin/env python3

from os import scandir, rename
from os.path import splitext, exists, join
from shutil import move
from time import sleep

import logging

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

source_dir = "/Users/serbanples/Downloads"
dest_dir_audio = "/Users/serbanples/Desktop/files/audios"
dest_dir_video = "/Users/serbanples/Desktop/files/videos"
dest_dir_image = "/Users/serbanples/Desktop/files/images"
dest_dir_document = "/Users/serbanples/Desktop/files/documents"
dest_dir_code = "/Users/serbanples/Desktop/files/code"

image_extensions = [".jpg", ".jpeg", ".jpe", ".jif", ".jfif", ".jfi", ".png", ".gif", 
                    ".apng", ".avif", ".pjpeg", ".pjp", ".k25", ".bmp", ".dib", ".heif", 
                    ".heic", ".ind", ".indd", ".indt", ".svg", ".webp", ".ico", ".cur", ".tif", ".tiff"]

video_extensions = [".webm", ".mpg", ".mp2", ".mpeg", ".mpe", ".mpv", ".ogg", ".mp4", ".mp4v", ".avi",
                    ".m4v", ".wmv", ".mov", ".qt", ".flv"]

audio_extensions = [".m4a", ".flac", ".mp3", ".wav", ".wma", ".aac"]

document_extensions = [".doc", ".docx", ".txt", ".pdf", ".xls", ".xlsx", ".ppt", ".pptx", ".odt"]

code_extensions = [".py", ".c", ".cpp", ".html", ".css", ".js", ".ts", ".jsx", ".tsx", ".java"]

def make_unique(dest, name):
    filename, extension = splitext(name)
    counter = 1
    while exists(f"{dest}/{name}"):
        name = f"{filename}({str(counter)}){extension}"
        counter += 1
    
    return name

def move_file(dest, entry, name):
    if exists(f"{dest}/{name}"):
        unique_name = make_unique(dest, name)
        oldName = join(dest, name)
        newName = join(dest, unique_name)
        rename(oldName, newName)
    move(entry, dest)

class MoverHandler(FileSystemEventHandler):
    def on_modified(self, event):
        with scandir(source_dir) as entries:
            for entry in entries:
                name = entry.name
                self.check_audio_files(entry, name)
                self.check_video_files(entry, name)
                self.check_image_files(entry, name)
                self.check_document_files(entry, name)
                self.check_code_files(entry, name)

    def check_audio_files(self, entry, name):
        for audio_extension in audio_extensions:
            if name.endswith(audio_extension) or name.endswith(audio_extension.upper()):
                move_file(dest_dir_audio, entry, name)
                logging.info(f"Moved audio file: {name}")

    def check_video_files(self, entry, name):
        for video_extension in video_extensions:
            if name.endswith(video_extension) or name.endswith(video_extension.upper()):
                move_file(dest_dir_video, entry, name)
                logging.info(f"Moved video file: {name}")
    
    def check_image_files(self, entry, name):
        for image_extension in image_extensions:
            if name.endswith(image_extension) or name.endswith(image_extension.upper()):
                move_file(dest_dir_image, entry, name)
                logging.info(f"Moved image file: {name}")

    def check_document_files(self, entry, name):
        for document_extension in document_extensions:
            if name.endswith(document_extension) or name.endswith(document_extension.upper()):
                move_file(dest_dir_document, entry, name)
                logging.info(f"Moved document file: {name}")

    def check_code_files(self, entry, name):
        for code_extension in code_extensions:
            if name.endswith(code_extension) or name.endswith(code_extension.upper()):
                move_file(dest_dir_code, entry, name)
                logging.info(f"Moved code file: {name}")


if __name__ == "__main__":
    logging.basicConfig(level = logging.INFO,
                        format = '%(asctime)s - %(message)s',
                        datefmt = '%Y-%m-%d %H:%M:%S')
    path = source_dir
    event_handler = MoverHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive = True)
    observer.start()
    try:
        while True:
            sleep(10)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()