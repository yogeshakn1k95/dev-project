from flask import Flask
import os
import mysql.connector

app = Flask(__name__)

@app.route("/")
def home():
    return "Backend Running 🚀"

@app.route("/db")
def db():
    try:
        conn = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            database="devopsdb"
        )

        cursor = conn.cursor()
        cursor.execute("SELECT DATABASE();")
        result = cursor.fetchone()

        return f"Connected to DB: {result}"

    except Exception as e:
        return str(e)

app.run(host="0.0.0.0", port=5000)
