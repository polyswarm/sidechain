FROM ethereum/client-go
LABEL maintainer="PolySwarm Developers <info@polyswarm.io>"

WORKDIR /root/.ethereum
COPY . .
RUN geth init polyswarm.json

EXPOSE 8545 8546 30303 30303/udp
