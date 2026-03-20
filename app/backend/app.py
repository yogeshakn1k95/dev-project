from flask import Flask
import os
import mysql.connector

app = Flask(__name__)

@app.route("/")
def home():
    return "Backend Running 🚀"

@app.route("/db")
def db():
    return f"DB USER: {os.getenv('DB_USER')}"

app.run(host="0.0.0.0", port=5000)
