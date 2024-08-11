#!/bin/bash

# add your a route to your lan here, via the docker gateway (in my case, 172.17.0.1)
ip route add to 192.168.1.0/24 via 172.17.0.1 dev eth0

# On my laptop I had to run add an additional route, as the docker was receiving my packets from this network
# ip route add to 192.168.65.0/24 via 172.17.0.1 dev eth0


