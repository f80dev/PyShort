#install docker
#sudo curl -sSL get.docker.com | sh

#arm
#FROM python:3

#pour les problemes de droit sur les répertoires : su -c "setenforce 0"
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /etc/letsencrypt/live/server.f80.fr:/app/certs -v /root/datas:/app/datas -v /root/clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest "ssl"

#lancement en non sécurisé
#su -c "setenforce 0" && docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /datas:/app/datas -v /clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest

#arm
#docker build -t f80hub/pyshort_arm . & docker push f80hub/pyshort_arm:latest
FROM arm32v7/python:3-alpine


#x86
#docker build -t f80hub/pyshort . & docker push f80hub/pyshort:latest
#docker rm -f pyshort && docker pull f80hub/pyshort:latest && docker run --restart=always -p 443:443 --name pyshort -d f80hub/pyshort:latest https://server.f80.fr 443 ssl
FROM jfloff/alpine-python



#Installation

RUN apk update
RUN apk --update add python

RUN pip3 install --upgrade pip
RUN pip3 install setuptools

RUN pip3 -v install Flask
RUN pip3 -v install db-sqlite3
RUN apk add py3-openssl

RUN apk --no-cache --update-cache add python3-dev


# Install dependencies

#docker build -t f80hub/cluster_bench_arm . & docker push f80hub/cluster_bench_arm:latest
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest


#test:docker run -p 5000:5000 -t f80hub/cluster_bench_arm:latest



#test SocketServer : http://45.77.160.220:5000

#arm
#docker build -t f80hub/cluster_bench_arm .
#docker push f80hub/cluster_bench_arm:latest
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /etc/letsencrypt/live/server.f80.fr:/app/certs -v /root/datas:/app/datas -v /root/clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest "ssl"

RUN mkdir /app
RUN mkdir /app/certs


WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip3 install pyqrcode
#RUN pip3 install -r requirements.txt

COPY . /app
COPY fullchain.pem ./certs
COPY privkey.pem ./certs

ENTRYPOINT ["python", "app.py"]