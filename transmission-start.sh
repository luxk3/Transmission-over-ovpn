#!/bin/sh
# `/sbin/setuser transmission-user` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.
# exec service transmission-daemon start >>/var/log/transmission.log 2>&1

exec /sbin/setuser transmission-user transmission-daemon -f --config-dir /etc/transmission-daemon/ >>/var/log/transmission.log 2>&1