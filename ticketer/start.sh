#!/bin/sh
/usr/sbin/sshd -D &

cd src
socat TCP-LISTEN:5000,reuseaddr,fork EXEC:"python3 -u main.py"