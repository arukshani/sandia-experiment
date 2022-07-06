#!/bin/bash

sudo apt-get install build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev libssl-dev

sudo chown -R $USER /opt
cd /opt
echo $(pwd)
git clone git@github.com:RedisLabs/memtier_benchmark.git
cd /opt/memtier_benchmark
echo $(pwd)
autoreconf -ivf
./configure
make
sudo make install

#memtier_benchmark --help
#memtier_benchmark -s 192.168.1.2 -p 11211 -P memcache_text --show-config