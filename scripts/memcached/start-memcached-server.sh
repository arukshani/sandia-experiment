#!/bin/bash

#Start memcached server
sudo systemctl restart memcached

#Check your new settings with ss to confirm the change:
output=$(sudo ss -plunt | grep memcached)
echo $output