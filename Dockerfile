FROM daocloud.io/library/ubuntu:14.04

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list /etc/apt/
RUN apt-get update

RUN apt-get install --no-install-recommends -y python make g++ redis-server lsof sysstat libkrb5-dev 2>/dev/null
RUN apt-get clean

RUN mkdir /root/download /root/gamepath

ADD mongodb_v3.2.9.tar.gz /root/download
ADD node-v4.4.7-linux-x64.tar.gz /root/download

RUN dpkg -i /root/download/*.deb 2>/dev/null

RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

WORKDIR /root/download/node-v4.4.7-linux-x64
RUN cp -r bin include lib share /usr/local
WORKDIR /root

ADD node-v4.4.7-headers.tar.gz /root/download
RUN mkdir -p /root/.node-gyp && cp -r /root/download/node-v4.4.7 /root/.node-gyp/4.4.7

RUN rm -rf /root/download

COPY server.sh /root/
RUN chmod +x /root/server.sh

VOLUME ["/root/gamepath", "/var/lib/mongodb"]

EXPOSE 27017

ENTRYPOINT ["/root/server.sh"]

