#!/bin/bash

# note: after -v put the host path you want to mount in the container in this form host_path:container_path
docker run -d -v /media/disk2:/media/disk2 -p 9091:9091 --cap-add=NET_ADMIN --device=/dev/net/tun  transmission-over-vpn

