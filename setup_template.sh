#!/bin/sh

if [ ! -f ssh_key.pub ]; then
    echo "ssh key missing.  Please put the deploy ssh key in ssh_key.pub"
    exit 1
fi

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

export PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin

TEMPLATE_DIR=$1
PLATFORM=$2

template/$PLATFORM-setup.sh $TEMPLATE_DIR

chroot $TEMPLATE_DIR useradd chefdeploy
chroot $TEMPLATE_DIR groupadd wheel

chroot $TEMPLATE_DIR gpasswd -a chefdeploy wheel
echo "%wheel         ALL = (ALL) NOPASSWD: ALL" > $TEMPLATE_DIR/etc/sudoers.d/passwordless_wheel

mkdir -p $TEMPLATE_DIR/home/chefdeploy/.ssh

chmod 700 $TEMPLATE_DIR/home/chefdeploy/.ssh

cp ssh_key.pub $TEMPLATE_DIR/home/chefdeploy/.ssh/authorized_keys
chmod 640 $TEMPLATE_DIR/home/chefdeploy/.ssh/authorized_keys

chroot $TEMPLATE_DIR chown -R chefdeploy:chefdeploy /home/chefdeploy
