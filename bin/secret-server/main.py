#!/usr/bin/env python3

import base64
import os
import secrets
import sqlite3

from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse

if not os.path.isdir("data"):
    os.mkdir("data")

db = sqlite3.connect("data/db.sqlite3", autocommit=True, check_same_thread=False)
db.execute("CREATE TABLE IF NOT EXISTS secrets (key TEXT PRIMARY KEY, value TEXT)")

app = FastAPI(docs_url=None, redoc_url=None)


@app.middleware("http")
async def check_auth(request: Request, next):
    try:
        auth = request.headers.get("Authorization")
        auth = base64.b64decode(auth.split(" ")[1]).decode("utf-8")
        username, password = auth.split(":")

        if not secrets.compare_digest(username, os.environ.get("SECRET_SERVER_USERNAME", "admin")):
            raise Exception()

        if not secrets.compare_digest(password, os.environ.get("SECRET_SERVER_PASSWORD", "admin")):
            raise Exception()

        return await next(request)
    except:
        return PlainTextResponse("Unauthorized", status_code=401)


@app.get("/")
def get_root():
    return {key: value for key, value in db.execute("SELECT key, value FROM secrets")}


@app.get("/{key}")
def get_key(key: str):
    value = db.execute("SELECT value FROM secrets WHERE key = ?", (key,)).fetchone()
    if not value:
        return PlainTextResponse("", status_code=404)

    return PlainTextResponse(value[0])


@app.post("/{key}")
async def post_key(key: str, request: Request):
    db.execute("INSERT OR REPLACE INTO secrets (key, value) VALUES (?, ?)", (key, await request.body()))
    return PlainTextResponse("OK")


@app.delete("/{key}")
def delete_key(key: str):
    if not db.execute("SELECT 1 FROM secrets WHERE key = ?", (key,)).fetchone():
        return PlainTextResponse("Not Found", status_code=404)

    db.execute("DELETE FROM secrets WHERE key = ?", (key,))
    return PlainTextResponse("OK")
