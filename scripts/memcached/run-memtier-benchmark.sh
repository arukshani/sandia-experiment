#!/bin/bash

#Only read requests
#memtier_benchmark -s 192.168.1.2 -p 11211 -P memcache_text --show-config --ratio=0:1
# ./scripts/memcached/run-memtier-benchmark.sh -s 10.1.2.200 -p 32 --separate-servers

mkdir -p /tmp/data-tmp
tmp_folder='/tmp/data-tmp'
timestamp=$(date +%d-%m-%Y_%H-%M-%S)

threads=1
clients_per_thread=20
requests_per_client=10000
TAR_FILENAME="memt-t$threads-c$clients_per_thread-r$requests_per_client-$timestamp.tar"

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
        logname="$tmp_folder/memt-$ip4-$timestamp.json"
        hdrprefix="$tmp_folder/memt-$ip4-$timestamp"
        echo >&2 "\t$i-th server: $current_server  port: $port"
    fi
    memtier_benchmark -s $current_server -p $port -P memcache_text --ratio=0:1 -t $threads -c $clients_per_thread -n $requests_per_client --json-out-file=$logname --hdr-file-prefix=$hdrprefix &
done
)

# echo $output 

cd /tmp/data-tmp && tar -czf $TAR_FILENAME $(cd /tmp/data-tmp && ls | grep $timestamp 2> /dev/null)
# rm -f /tmp/data-tmp/*$timestamp* !(TAR_FILENAME)
find . -type f ! -name "*$timestamp.tar" -exec rm -rf {} \;
# cd /tmp/ && rm -f $LOGS