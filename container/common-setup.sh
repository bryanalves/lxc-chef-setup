#!/bin/sh

useradd chefdeploy
groupadd wheel
gpasswd -a chefdeploy wheel
echo "%wheel         ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/passwordless_wheel

mkdir -p /home/chefdeploy/.ssh

chmod 700 /home/chefdeploy/.ssh

touch /home/chefdeploy/.ssh/authorized_keys

chmod 640 /home/chefdeploy/.ssh/authorized_keys

chown -R chefdeploy:chefdeploy /home/chefdeploy
