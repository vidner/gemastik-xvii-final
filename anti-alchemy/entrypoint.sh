#!/bin/bash

/usr/sbin/sshd -D &
sleep 3
python3 ./misc/init_users.py
su ctf -c "gunicorn --bind 0.0.0.0:5000 --timeout 60 --workers 6 app:app"