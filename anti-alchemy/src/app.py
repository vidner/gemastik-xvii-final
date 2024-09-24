from flask import Flask, render_template, session, redirect, url_for
from os import environ

from antialchemy import *
from helper import *

app = Flask(__name__)
app.config["SECRET_KEY"] = environ.get("SECRET_KEY", "SECRET_KEY")
app.config["PERMANENT_SESSION_LIFETIME"] = 3 * 60
qb = QueryBuilder()


@app.get("/api/flag")
@check_login_status
def flag():
    if session["user"] == "admin":
        try:
            return make_resp(200, open("/flag.txt").read())
        except:
            return make_resp(500, "Flag not found, please contact problem setter")

    return make_resp(401, "You need to log in as admin to get the flag")


@app.post("/api/login")
@check_request_body
def login(*args, **kwargs):
    payload = kwargs.copy()

    try:
        conn = create_db_conn()
        cur = conn.cursor()
        cur.execute(
            qb.generate(
                {
                    "table": "users",
                    "username": payload["username"],
                }
            )
        )
        row = cur.fetchone()
        if not row:
            return make_resp(401, "Invalid username/password")

        _, username, password_hash = row
        password = payload.pop("password")

        cur.execute(
            qb.generate(
                {
                    "table": "salt",
                    "username": username,
                }
            )
        )
        row = cur.fetchone()
        if not row:
            return make_resp(401, "Invalid username/password")

        _, _, salt = row

        if not check_password_hash(password, salt, password_hash):
            return make_resp(401, "Invalid username/password")

        session.clear()
        session["user"] = username
        return redirect(url_for("index"))

    except Exception as e:
        print(f"Exception: {e}")
        return make_resp(400, "Bad Request")

    finally:
        cur.close()
        conn.close()


@app.get("/api/logout")
@check_login_status
def logout():
    session.clear()
    return redirect(url_for("index"))


@app.post("/api/view")
@check_login_status
@check_request_body
def view(*args, **kwargs):
    payload = kwargs.copy()

    try:
        conn = create_db_conn()
        cur = conn.cursor()
        cur.execute(qb.generate(payload | {"table": "cwe"}))
        rows = cur.fetchall()
        return make_resp(200, "OK", {"rows": rows})

    except Exception as e:
        print(f"Exception: {e}")
        return make_resp(400, "Bad Request")

    finally:
        cur.close()
        conn.close()


@app.get("/")
def index():
    try:
        if session["user"]:
            return render_template("dashboard.html")
    except:
        pass

    return render_template("login.html")


if __name__ == "__main__":
    app.run(debug=True)
