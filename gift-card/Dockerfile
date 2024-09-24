FROM public.ecr.aws/docker/library/python:3.11-slim-buster

ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && apt-get install -y openssh-server curl socat nano
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

WORKDIR /ctf/gift-card

COPY src/ src/
COPY start.sh .

RUN chmod +x start.sh
CMD ./start.sh