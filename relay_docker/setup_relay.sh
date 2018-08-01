#! /bin/bash

echo ENODE=$(cat /root/bootnode/enode) > .env
echo ENODE_IP=$1 >> .env
echo ADDRESS=$2 >> .env

cp /root/docker/config.toml /root/relay/docker

docker-compose -f relay.yml up -d