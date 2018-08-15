#! /bin/bash

add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install ethereum -y

cd bootnode

tmux new-session -d -s bootnode 'bootnode -nodekey ./nodekey -verbosity 9'