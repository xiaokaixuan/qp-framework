FROM daocloud.io/library/node:8.0.0-alpine

RUN mv /etc/apk/repositories /etc/apk/repositories.old && \
    echo -e 'https://mirrors.aliyun.com/alpine/v3.6/main\nhttps://mirrors.aliyun.com/alpine/v3.6/community' >/etc/apk/repositories && \
    apk add --no-cache --update-cache tzdata curl bash python make g++ redis mongodb lsof sysstat krb5-dev && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone && \
    mkdir -p /root/download /root/gamepath /root/.node-gyp/8.0.0 && \
    curl 'http://cdn.npm.taobao.org/dist/node/v8.0.0/node-v8.0.0-headers.tar.gz' -Lso /root/download/node-v8.0.0-headers.tar.gz && \
    tar --strip-components 1 -C /root/.node-gyp/8.0.0 -zxf /root/download/node-v8.0.0-headers.tar.gz && \
    echo 9 >/root/.node-gyp/8.0.0/installVersion && rm -rf /root/download

COPY server.sh /root/
RUN chmod +x /root/server.sh

VOLUME ["/root/gamepath", "/var/lib/mongodb"]

EXPOSE 27017

ENTRYPOINT ["/root/server.sh"]

