#!/usr/bin/env python3

import base64
import os
import secrets
import sqlite3

from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse

if not os.path.isdir("data"):
    os.mkdir("data")

db = sqlite3.connect("data/db.sqlite3", check_same_thread=False)
if db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='secrets'").fetchone() is None:
    db.execute("CREATE TABLE secrets (key TEXT PRIMARY KEY, value TEXT)")
    db.commit()

app = FastAPI(docs_url=None, redoc_url=None)


@app.middleware("http")
async def check_auth(request: Request, call_next):
    auth = request.headers.get("Authorization")
    if not auth:
        return PlainTextResponse("Unauthorized", status_code=401, headers={"WWW-Authenticate": "Basic"})

    auth = base64.b64decode(auth.split(" ")[1]).decode("utf-8")
    username, password = auth.split(":")
    if not secrets.compare_digest(username, os.environ.get("SECRET_SERVER_USERNAME", "admin")):
        return PlainTextResponse("Unauthorized", status_code=401, headers={"WWW-Authenticate": "Basic"})

    if not secrets.compare_digest(password, os.environ.get("SECRET_SERVER_PASSWORD", "admin")):
        return PlainTextResponse("Unauthorized", status_code=401, headers={"WWW-Authenticate": "Basic"})

    return await call_next(request)


@app.get("/")
def get_root():
    return {key: value for key, value in db.execute("SELECT key, value FROM secrets")}


@app.get("/{key}", response_class=PlainTextResponse)
def get_key(key: str):
    value = db.execute("SELECT value FROM secrets WHERE key = ?", (key,)).fetchone()
    return value[0] if value else ""


@app.post("/{key}", response_class=PlainTextResponse)
async def post_key(key: str, request: Request):
    db.execute("INSERT OR REPLACE INTO secrets (key, value) VALUES (?, ?)", (key, await request.body()))
    db.commit()
    return "OK"


@app.delete("/{key}", response_class=PlainTextResponse)
def delete_key(key: str):
    db.execute("DELETE FROM secrets WHERE key = ?", (key,))
    db.commit()
    return "OK"
