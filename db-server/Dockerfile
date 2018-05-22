FROM daocloud.io/library/ubuntu:14.04

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone
RUN mv /etc/apt/sources.list /etc/apt/sources.list.old
COPY sources.list /etc/apt/
RUN apt-get update \
    && apt-get install --no-install-recommends -y redis-server 2>/dev/null \
    && apt-get clean

RUN mkdir /root/download

ADD mongodb_v3.2.9.tar.gz /root/download/

RUN dpkg -i /root/download/*.deb 2>/dev/null \
    && sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf /etc/redis/redis.conf

COPY server.sh /root/
RUN chmod +x /root/server.sh

VOLUME ["/var/lib/mongodb"]

EXPOSE 27017
EXPOSE 6379

ENTRYPOINT ["/root/server.sh"]

