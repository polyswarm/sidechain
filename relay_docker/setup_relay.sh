#! /bin/bash

ENODE=$1 > .env
ENODE_IP=$2 >> .env
ADDRESS=$3 >> .env

mv /root/docker/config.toml /root/relay/docker

docker-compose -f relay.yml up -d