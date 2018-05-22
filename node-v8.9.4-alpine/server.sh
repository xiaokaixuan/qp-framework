#!/bin/bash

/usr/bin/redis-server /etc/redis.conf

/usr/bin/mongod --fork --bind_ip 0.0.0.0 --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log

/usr/bin/redis-cli flushall

cd /root/gamepath

[ ! -e /root/.npm_rebuild -a -e node_modules ] && npm rebuild --loglevel warn && touch /root/.npm_rebuild

[ -e node_modules/.bin/memdbcluster ] && { node_modules/.bin/memdbcluster start -c config/memdb.conf.js || exit $?; }

sleep 1 && [ -e node_modules/.bin/pomelo ] && node_modules/.bin/pomelo start "$@"

