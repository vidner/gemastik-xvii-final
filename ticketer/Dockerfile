FROM public.ecr.aws/docker/library/ubuntu:24.04

ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && apt-get install -y openssh-server curl socat gcc libgmp3-dev python3 python3-pip
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

WORKDIR /ctf/ticketer

COPY src/ src/
COPY start.sh .

RUN pip install fastecdsa --break-system-packages
RUN touch flag.txt

RUN chmod +x start.sh
CMD ./start.sh

# docker build --build-arg "PASSWORD=123" -t ticketer .