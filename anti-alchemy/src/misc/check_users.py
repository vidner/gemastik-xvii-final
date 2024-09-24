import sys
sys.path += [".", ".."]

from helper import create_db_conn
from os import environ

print("Getting environment variables...")
print(environ.get("SECRET_KEY", "SECRET_KEY"))
print()

print("Getting rows of users and salt...")
conn = create_db_conn()
cur = conn.cursor()

cur.execute("SELECT * FROM users")
rows = cur.fetchall()
for row in rows:
    print(row)

cur.execute("SELECT * FROM salt")
rows = cur.fetchall()
for row in rows:
    print(row)
print()

print("Done")
cur.close()
conn.close()
