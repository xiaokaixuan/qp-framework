FROM daocloud.io/xiaokaixuan/node:8.9.4-alpine

RUN mv /etc/apk/repositories /etc/apk/repositories.old && \
    echo -e 'https://mirrors.aliyun.com/alpine/v3.6/main\nhttps://mirrors.aliyun.com/alpine/v3.6/community' >/etc/apk/repositories && \
    apk add --no-cache --update-cache tzdata curl bash python make g++ redis mongodb lsof sysstat krb5-dev && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone && \
    mkdir -p /root/gamepath /root/.node-gyp/$NODE_VERSION /root/download && \
    curl "http://cdn.npm.taobao.org/dist/node/v$NODE_VERSION/node-v$NODE_VERSION-headers.tar.gz" -Lso /root/download/node-v$NODE_VERSION-headers.tar.gz && \
    tar --strip-components 1 -C /root/.node-gyp/$NODE_VERSION -zxf /root/download/node-v$NODE_VERSION-headers.tar.gz && \
    echo 9 >/root/.node-gyp/$NODE_VERSION/installVersion && \
    rm -rf /root/download

COPY server.sh /root/
RUN chmod +x /root/server.sh

VOLUME ["/root/gamepath", "/var/lib/mongodb"]

EXPOSE 27017

ENTRYPOINT ["/root/server.sh"]

