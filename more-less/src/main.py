from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse
from yaml import load, Loader

app = FastAPI()
html = open("index.html").read()

@app.get("/")
def index():
    return HTMLResponse(content=html, status_code=200)

@app.post("/")
def upload_file(file: UploadFile = File(...)):
    return load(file.file, Loader=Loader)