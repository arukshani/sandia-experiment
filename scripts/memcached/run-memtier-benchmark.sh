#!/bin/bash

#Only read requests
#memtier_benchmark -s 192.168.1.2 -p 11211 -P memcache_text --show-config --ratio=0:1

parallelism=1
server=127.0.0.1

for arg in "$@"
do
case $arg in
    -p|--parallel)
        shift
        parallelism=$1
        shift
        ;;
    -s|--server)
        shift
        server=$1
        shift
        ;;
    --separate-servers)
        shift
        USE_SEPARATE_SERVER=1
        ;;
esac
done

IFACE=ens1f0

# set -x
output=$(
for i in $(seq 1 $parallelism); do
    port=$(echo "11211+$i" | bc);
    current_server=$server
    if [[ $USE_SEPARATE_SERVER -eq 1 ]]; then
        # echo >&2 "Using separate servers ..."
        IFS='.' read ip1 ip2 ip3 ip4 <<< "$server"
        ip2=$(echo "1 + ($i - 1) / 32" | bc)
        ip4=$(echo "$ip4 + ($i - 1) % 32 + 1" | bc)
        current_server="$ip1.$ip2.$ip3.$ip4"
        echo >&2 "\t$i-th server: $current_server  port: $port"
    fi
    memtier_benchmark -s $current_server -p $port -P memcache_text --ratio=0:1 &
done
)

echo $output 