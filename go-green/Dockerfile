FROM public.ecr.aws/docker/library/golang:bullseye

ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && apt-get install -y openssh-server xinetd curl
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

RUN useradd -m ctf

WORKDIR /ctf

RUN echo "Connection blocked" > /etc/banner_fail
COPY ctf.xinetd /etc/xinetd.d/ctf
COPY ./src/main.go ./
COPY ./run.sh ./
COPY ./start.sh ./

RUN go build main.go

RUN touch /flag.txt
RUN chmod -R 755 /ctf
RUN chmod +x /ctf/start.sh

CMD ./start.sh

EXPOSE 8000