import sys
sys.path += [".", ".."]

from helper import create_db_conn, generate_password_hash
from os import environ, urandom

conn = create_db_conn()
cur = conn.cursor()

users = [
    ("admin", environ.get("SECRET_KEY", "SECRET_KEY"), urandom(8).hex()),
    ("gemastik", "P@ssw0rd", urandom(8).hex()),
]

for username, password, salt in users:
    cur.execute(
        "INSERT INTO users (username, password) VALUES (%s, %s)",
        (username, generate_password_hash(password, salt)),
    )
    cur.execute("INSERT INTO salt (username, salt) VALUES (%s, %s)", (username, salt))

conn.commit()

cur.close()
conn.close()
