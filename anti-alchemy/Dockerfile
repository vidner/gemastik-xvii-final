FROM public.ecr.aws/docker/library/python:3.11-slim-buster

ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && apt-get install -y openssh-server curl nano
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start
RUN useradd --user-group --system --create-home --no-log-init --shell /bin/bash ctf

WORKDIR /home/ctf/app

COPY requirements.txt .
RUN pip install -r ./requirements.txt && rm ./requirements.txt

COPY src/ .

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]