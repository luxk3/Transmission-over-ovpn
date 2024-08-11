# Docker container with Transmission and OpenVPN Client

This repository contains the file necessary to generate a Docker container that will run Transmission and OpenVPN client.
The repository contains also the files necessary to ensure that connections from local networks towards the Transmission web portal are routed correctly when the VPN is up.

## Dockerfile
The container is base on the phusion [phusion.github.io](http://phusion.github.io/baseimage-docker/) base-image docker. This image contains a init process that starts one or more "services". The init process takes care of restarting the services in case they stop or crash. Refer to the _phusion_ documentation to see how it works.



## Phusion base-image services

The Dockerfile installs the requirements and starts the 2 services:
- transmission-start.sh
- ovpn-start.sh

## OpenVPN settings
To copy your vpn configuration make sure you generate a ovpn.tar.gz file contining your OpenVPN files. 
The structure inside the tar.gz should be:\
ovpn/\
|_ ca.crt\
|_ your_ovpn.conf\
|_ other files if necessary

## Transmission settings
The transmission settings are saved in the file _settings.json_. This files contains download paths, network whitelist for connecting to the webporal, and **username** and **password**.\
To configure Transmission for your needs, make sure:
1. Set the correct **username** and **password** in the file before building the container. Default username is `changeme-user` and default password is `changeme-password`
2. Change the whitelist network setting `rpc-whitelist` with your LAN or set `rpc-whitelist-enabled` to false.

## Build and export the Docker container
To build the docker container issue the following command:
```
# ensure your Docker daemon is running
# inside the folder with the Dockerfile
$ docker build . -t transmission-over-ovpn
```

To export the image to a file:
`$ docker save -o transmission-over-vpn transmission-over-vpn`

To load the image in another systes:
`# docker load -i transmission-over-ovpn`


## Docker networking
To make sure that the services inside the Docker contaiers are reacheable from the LAN when OpenVPN is running, it is necessary to add specific routes from those networks. The rout are added into the *add_local_routes.sh*. 
Add this script in the OpenVPN configuration file under the _up_ primitive:\
Example in *your_ovpn.conf*:
```
...
...
up /etc/openvpn/add_local_routes.sh
...
```

## Start the docker container
`docker run -d -v /media/disk2:/media/disk2 -p 9091:9091 --cap-add=NET_ADMIN --device=/dev/net/tun  transmission-over-vpn`\
Flags:
- `-v` mounts the volume
- `-d` detached, run the container detached from the terminal session
- `-p` port binding. host_port:container_port

This command does 4 things:
- start the image _transmission-over-ovpn_
- creates a _tun_ interface for the vpn
- binds the port 9091 of the container(guest) to 0.0.0.0:9091 of the host
- mount a folder (docker volume bind) from the host into a volume in the container
