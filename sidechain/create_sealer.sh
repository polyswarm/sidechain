#! /bin/bash

curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd sidechain
echo ENODE=$(cat /root/bootnode/enode) > .env
echo ENODE_IP=$1 >> .env
echo ADDRESS=$2 >> .env
docker-compose -f docker/sidechain.yml up -d