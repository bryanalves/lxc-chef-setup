#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

echo "Starting chef setup:"
hostname

echo

echo "Waiting for network"
while ! ip route | grep default > /dev/null; do
    printf .
    sleep 1
done

echo

useradd chefdeploy
groupadd wheel

apt-get install --force-yes -fuy debian-keyring
apt-get update
apt-get install sudo
gpasswd -a chefdeploy wheel
echo "%wheel         ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/passwordless_wheel

mkdir -p /home/chefdeploy/.ssh

chmod 700 /home/chefdeploy/.ssh

apt-get install -y chef
