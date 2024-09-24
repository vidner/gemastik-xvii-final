#!/bin/bash

/usr/sbin/sshd -D &
su ctf -c "fastapi run"