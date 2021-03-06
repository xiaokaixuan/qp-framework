FROM daocloud.io/library/ubuntu:14.04

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone
RUN mv /etc/apt/sources.list /etc/apt/sources.list.old
COPY sources.list /etc/apt/
RUN apt-get update \
    && apt-get install --no-install-recommends -y runit python make g++ redis-server lsof sysstat libkrb5-dev 2>/dev/null \
    && apt-get clean

RUN mkdir /root/download /root/gamepath

ADD db-server/mongodb_v3.2.9.tar.gz db-server/node-v4.4.7-linux-x64.tar.gz node-v4.4.7-headers.tar.gz /root/download/

RUN dpkg -i /root/download/*.deb 2>/dev/null \
    && sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf /etc/redis/redis.conf \
    && echo 'save ""' >> /etc/redis/redis.conf

WORKDIR /root/download/node-v4.4.7-linux-x64
RUN cp -r bin include lib share /usr/local/
WORKDIR /root

RUN mkdir -p /root/.node-gyp \
    && cp -r /root/download/node-v4.4.7 /root/.node-gyp/4.4.7 \
    && echo 9 >/root/.node-gyp/4.4.7/installVersion

ADD db-server/service /root/service
COPY server.sh /root/

RUN find /root/service -type f -name 'run' -exec chmod +x {} \; \
    && chmod +x /root/server.sh

VOLUME ["/root/gamepath", "/var/lib/mongodb"]

EXPOSE 27017
EXPOSE 6379

ENV DB_SERVER=

ENTRYPOINT ["/root/server.sh"]

