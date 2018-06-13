#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf daemonize no &

/usr/bin/mongod --quiet --config /etc/mongod.conf &

sleep 1 && /usr/bin/redis-cli flushall

cd /root/gamepath

[ ! -e /root/.npm_rebuild -a -e node_modules ] && npm rebuild && touch /root/.npm_rebuild

[ -e node_modules/.bin/memdbcluster ] && { node_modules/.bin/memdbcluster start -c config/memdb.conf.js || exit $?; }

sleep 1 && [ -e node_modules/.bin/pomelo ] && node_modules/.bin/pomelo start "$@" &

PID0=$!

PIDS=`pgrep node` PID1=`pgrep redis-server` PID2=`pgrep mongod`

trap '[ -e node_modules/.bin/memdbcluster ] && node_modules/.bin/memdbcluster stop -c config/memdb.conf.js; [ "$PIDS" -o "$PID1" -o "$PID2" ] && kill $PIDS $PID1 $PID2 2>/dev/null' SIGINT SIGTERM

wait $PID0
wait $PID1
wait $PID2

