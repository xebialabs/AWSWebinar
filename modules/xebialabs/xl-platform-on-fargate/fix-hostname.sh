#!/bin/sh
echo "Contents of /etc/hosts"
cat /etc/hosts
echo "Adding following line to /etc/hosts"
echo "$(hostname -I | cut -d\  -f 1) $(hostname)"
echo "$(hostname -I | cut -d\  -f 1) $(hostname)" >> /etc/hosts

exec /opt/xebialabs/xl-release-server/bin/run-in-container.sh
