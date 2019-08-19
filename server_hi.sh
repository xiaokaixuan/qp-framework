#!/bin/bash

[ $DB_SERVER ] && { /usr/bin/runsvdir /root/service & }

PID1=$!

sleep 1 && cd /root/gamepath

[ ! -e /root/.npm_rebuild -a -e node_modules ] && npm rebuild && touch /root/.npm_rebuild && exit 0

[ $DB_SERVER ] && [ -e node_modules/.bin/memdbcluster ] && { node_modules/.bin/memdbcluster start -c config/memdb.conf.js || exit $?; }

sleep 1 && [ -e node_modules/.bin/pomelo ] && { NODE_OPTIONS='--require ./old_version' node_modules/.bin/pomelo start "$@" & }

PID0=$!

trap 'kill $(pgrep -f app.js); [ $DB_SERVER ] && [ -e node_modules/.bin/memdbcluster ] && node_modules/.bin/memdbcluster stop -c config/memdb.conf.js; [ "$PID1" ] && kill $PID1' SIGINT SIGTERM

wait $PID0
wait $PID1
