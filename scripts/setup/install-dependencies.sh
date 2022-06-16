#!/bin/bash

cwd="$(pwd)"
cd "$(dirname "$0")"

sudo apt-get -y install zsh net-tools iperf3 numactl

tempdir=$(mktemp -d)
cd $tempdir

# Install Mellanox OFED

wget https://content.mellanox.com/ofed/MLNX_OFED-5.6-2.0.9.0/MLNX_OFED_LINUX-5.6-2.0.9.0-ubuntu20.04-x86_64.tgz

tar zxf MLNX_OFED_LINUX-5.6-2.0.9.0-ubuntu20.04-x86_64.tgz
cd MLNX_OFED_LINUX-5.6-2.0.9.0-ubuntu20.04-x86_64

sudo ./mlnxofedinstall --upstream-libs
##RESTART the machines and then run the following 
# sudo /etc/init.d/openibd restart

# Install Mellanxo IRQ affinity tools if needed. Modern OFED often includes these tools.
# if ! [ -x "`command -v set_irq_affinity_bynode.sh`" ]; then
#     wget http://www.mellanox.com/relateddocs/prod_software/mlnx_irq_affinity.tgz
#     tar xzf mlnx_irq_affinity.tgz --directory=/usr/sbin/ --overwrite
# fi

cd "$cwd"
