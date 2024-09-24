FROM public.ecr.aws/docker/library/alpine:latest

ARG PASSWORD

RUN \
  apk update && \
  apk add openrc --no-cache && \
  apk add openssh-server && \
  apk add openssl && \
  rc-update add sshd && \
  rc-status && \
  touch /run/openrc/softlevel 

RUN echo root:${PASSWORD} | chpasswd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

RUN apk add bash curl shadow
RUN chsh -s /bin/bash root

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gleam rebar3 make gcc musl-dev
ADD https://raw.githubusercontent.com/openembedded/openembedded-core/master/meta/recipes-core/musl/bsd-headers/sys-queue.h /usr/include/sys/queue.h

WORKDIR /ctf/gleam-drive

COPY src src/
COPY *.toml .
COPY start.sh .

RUN gleam build

RUN cat /dev/urandom | head -c 16 > .aes-key
RUN openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=GleamDriveState/L=GleamDriveCity/O=GleamDriveCompany/OU=GleamDriveCompanySection/CN=GleamDrive"

RUN chmod +x start.sh
CMD ./start.sh