#!/bin/sh
/usr/sbin/sshd -D &
/usr/sbin/xinetd -dontfork