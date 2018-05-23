#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf daemonize no &

/usr/bin/mongod --quiet --config /etc/mongod.conf &

PID1=`pgrep redis-server` PID2=`pgrep mongod`

trap 'kill $PID1 $PID2' SIGINT SIGTERM

wait $PID1
wait $PID2

