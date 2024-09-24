FROM public.ecr.aws/docker/library/node

ARG PASSWORD

RUN echo root:${PASSWORD} | chpasswd
RUN apt-get update && apt-get install -y openssh-server curl
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh start

WORKDIR /ctf/kode-viewer/

COPY package*.json ./
RUN npm install

COPY src/ src/
COPY views/ views/
COPY public/ public/
COPY *.json .
COPY start.sh .

RUN npm run build

RUN chmod +x start.sh
CMD ./start.sh