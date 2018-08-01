#! /bin/bash

ENODE=$1 > .env
ENODE_IP=$2 >> .env
ADDRESS=$3 >> .env

mv /root/docker/config.toml /root/relay/docker

git clone https://github.com/polyswarm/relay
docker-compose -f relay.yml up -d