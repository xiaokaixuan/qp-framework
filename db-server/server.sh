#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf

/usr/bin/mongod --quiet --config /etc/mongod.conf

