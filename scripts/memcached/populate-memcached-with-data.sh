#!/bin/bash

server=127.0.0.1
port=11211

for arg in "$@"
do
case $arg in
    -s|--server)
        shift
        server=$1
        shift
        ;;
    -p|--port)
        shift
        port=$1
        shift
        ;;
esac
done

echo $server
echo $port

# memtier_benchmark -s 10.1.2.201 -p 11212 -P memcache_text --show-config --ratio=1:0 --requests 20000

#populate 19976 items; Data size:32 bytes; Key Size:9-16 bytes; memcached protocol - text; Key pattern:random
#number of threads:4; number of clients per thread:50; number of requests per client:20000;
memtier_benchmark -s $server -p $port -P memcache_text --show-config --ratio=1:0 --requests 20000