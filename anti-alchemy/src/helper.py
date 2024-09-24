from flask import request, session
from functools import wraps
from hashlib import sha1
from json import dumps
from os import environ
from psycopg2 import connect
from string import printable
from time import sleep

def create_db_conn():
    while True:
        try:
            return connect(
                database=environ.get("DB_NAME", "postgres"),
                user=environ.get("DB_USER", "postgres"),
                password=environ.get("DB_PASS", "password"),
                host=environ.get("DB_HOST", "localhost"),
                port=environ.get("DB_PORT", "5432"),
            )
        except:
            sleep(1)


def make_resp(status, message, data=None):
    return {"status": status, "message": message, "data": data}


def generate_password_hash(password, salt):
    return sha1((salt + password).encode()).hexdigest()


def check_password_hash(password, salt, password_hash):
    return generate_password_hash(password, salt) == password_hash


def check_login_status(f):
    @wraps(f)
    def inner(*args, **kwargs):
        try:
            session["user"]
            return f(*args, **kwargs)

        except Exception as e:
            print(f"Exception: {e}")
            return make_resp(401, "Unauthorized")

    return inner


def check_request_body(f):
    check_blist = lambda s: all(x not in s.lower() for x in ["pg_"])
    check_wlist = lambda s: all(c in printable for c in s)

    @wraps(f)
    def inner(*args, **kwargs):
        try:
            data = request.get_json()
            data = {k: v for k, v in data.items() if data.get(k)}

            dd = dumps(data, separators=(",", ":"))
            assert len(dd) < 256 and check_blist(dd), "Bad payload"

            for item in data.items():
                assert all(map(check_wlist, item)), "Bad payload"

            kwargs.update(data)
            return f(*args, **kwargs)

        except Exception as e:
            print(f"Exception: {e}")
            return make_resp(400, "Bad Request")

    return inner
