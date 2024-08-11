# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:jammy-1.0.4

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update
RUN apt-get install openvpn -y
RUN apt-get install transmission transmission-daemon -y
RUN apt-get install python3 -y
RUN apt-get install iputils-ping net-tools tcpdump -y



# VPN setup #desination folder is already /ovpn
RUN mkdir /ovpn
ADD your_ovpn.conf /ovpn/your_ovpn.conf
ADD your_ca.crt /ovpn/your_ca.crt
# RUN chmod a+x /ovpn/update-resolv-conf

ADD add_local_routes.sh /etc/openvpn/add_local_routes.sh
RUN chmod a+x /etc/openvpn/add_local_routes.sh
# RUN cp /ovpn/update-resolv-conf /etc/openvpn/update-resolv-conf



# creating a user to run Tranmission inside the container as a non-root user
RUN adduser --no-create-home --disabled-login --disabled-password transmission-user
RUN groupadd transmission-user-group
RUN usermod -a -G transmission-user-group transmission-user

# changing ownership: transmission saves tmp files in this folder
RUN chown -R transmission-user:transmission-user-group /etc/transmission-daemon

# Copy the Transmission service files and conifg
RUN mkdir /etc/service/transmission-start
ADD transmission-start.sh /etc/service/transmission-start/run
RUN chmod a+x /etc/service/transmission-start/run
ADD settings.json /etc/transmission-daemon/settings.json

# copy the OpenVPN services files and config
RUN mkdir /etc/service/ovpn-start
ADD ovpn-start.sh /etc/service/ovpn-start/run
RUN chmod a+x /etc/service/ovpn-start/run



# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*