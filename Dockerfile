#install docker
#sudo curl -sSL get.docker.com | sh

#arm
#FROM python:3
#docker build -t f80hub/PyShortArm . & docker push f80hub/PyShortArm:latest
#pour les problemes de droit sur les répertoires : su -c "setenforce 0"
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /etc/letsencrypt/live/server.f80.fr:/app/certs -v /root/datas:/app/datas -v /root/clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest "ssl"

#lancement en non sécurisé
#su -c "setenforce 0" && docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /datas:/app/datas -v /clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest

#arm
FROM arm32v7/python:3-alpine
RUN pip3 -v install Flask
RUN pip3 -v install sqlite3
RUN apk add py3-openssl


# Install dependencies

#docker build -t f80hub/cluster_bench_arm . & docker push f80hub/cluster_bench_arm:latest
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest
#docker run --restart=always -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest


#test:docker run -p 5000:5000 -t f80hub/cluster_bench_arm:latest



#test SocketServer : http://45.77.160.220:5000

#arm
#docker build -t f80hub/cluster_bench_arm .
#docker push f80hub/cluster_bench_arm:latest
#docker rm -f clusterbench && docker pull f80hub/cluster_bench_arm:latest && docker run --restart=always -v /etc/letsencrypt/live/server.f80.fr:/app/certs -v /root/datas:/app/datas -v /root/clustering:/app/clustering -p 5000:5000 --name clusterbench -d f80hub/cluster_bench_arm:latest "ssl"

EXPOSE 80

RUN mkdir /app

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip3 install --upgrade pip
RUN pip3 install setuptools

RUN pip3 install -r requirements.txt

COPY . /app

ENTRYPOINT ["python", "app.py"]