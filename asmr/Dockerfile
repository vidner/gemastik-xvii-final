FROM public.ecr.aws/docker/library/ubuntu:24.04@sha256:dfc10878be8d8fc9c61cbff33166cb1d1fe44391539243703c72766894fa834a

ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        xinetd \
        curl \
        python3 \
        python3-pip \
        python3-setuptools && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists

RUN pip3 install --break-system-packages unicorn

RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

RUN useradd -m ctf

WORKDIR /ctf

RUN echo "Connection blocked" > /etc/banner_fail
COPY ctf.xinetd /etc/xinetd.d/ctf
COPY ./src/asmr.py ./
COPY ./run.sh ./
COPY ./start.sh ./

RUN touch /flag.txt
RUN chmod -R 755 /ctf
RUN chmod +x /ctf/start.sh

CMD ./start.sh

EXPOSE 8000
