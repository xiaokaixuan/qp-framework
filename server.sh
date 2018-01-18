#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf

/usr/bin/mongod --fork --config /etc/mongod.conf

/usr/bin/redis-cli flushall

cd /root/gamepath

[ ! -e /root/.npm_rebuild -a -e node_modules ] && npm rebuild && touch /root/.npm_rebuild

[ -e node_modules/.bin/memdbcluster ] && node_modules/.bin/memdbcluster start -c config/memdb.conf.js && sleep 1

[ -e node_modules/.bin/pomelo ] && node_modules/.bin/pomelo start "$@"


