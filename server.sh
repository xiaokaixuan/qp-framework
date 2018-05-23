#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf daemonize no &

/usr/bin/mongod --quiet --config /etc/mongod.conf &

PID1=`pgrep redis-server` PID2=`pgrep mongod`

/usr/bin/redis-cli flushall

cd /root/gamepath

[ ! -e /root/.npm_rebuild -a -e node_modules ] && npm rebuild && touch /root/.npm_rebuild

[ -e node_modules/.bin/memdbcluster ] && { node_modules/.bin/memdbcluster start -c config/memdb.conf.js || exit $?; }

sleep 1 && [ -e node_modules/.bin/pomelo ] && node_modules/.bin/pomelo start "$@" &

PID0=$!

trap '[ -e node_modules/.bin/memdbcluster ] && node_modules/.bin/memdbcluster stop -c config/memdb.conf.js; [ "$PID0" -o "$PID1" -o "$PID2" ] && kill $PID0 $PID1 $PID2' SIGINT SIGTERM

wait $PID0
wait $PID1
wait $PID2

