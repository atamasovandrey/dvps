from fastapi import FastAPI

app = FastAPI()
VERSION = "0.1.0"


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/")
def root():
    return {"service": "uptime-checker", "version": VERSION}
