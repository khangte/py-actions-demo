from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/add")
def add(a: int, b: int):
    return {"result": a + b}

@app.get("/subtract")
def subtract(a: int, b: int):
    return {"result": a - b}
