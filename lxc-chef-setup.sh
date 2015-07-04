#!/bin/sh

if [ ! -f ssh_key.pub ]; then
    echo "ssh key missing.  Please put the deploy ssh key in ssh_key.pub"
    exit 1
fi

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

LXC_TARGET=$1

lxc-start -n $LXC_TARGET 2> /dev/null

<debian-setup.sh lxc-attach -n $1 -- /bin/sh -c "/bin/cat > /root/chef-setup.sh ; /bin/chmod +x /root/chef-setup.sh"

lxc-attach -n $1 --clear-env -- /root/chef-setup.sh

<ssh_key.pub lxc-attach -n $1 --clear-env -- /bin/sh -c "/bin/cat >> /home/chefdeploy/.ssh/authorized_keys ; /bin/chmod 640 /home/chefdeploy/.ssh/authorized_keys"
lxc-attach -n $1 --clear-env -- /bin/sh -c "/bin/chown -R chefdeploy:chefdeploy /home/chefdeploy"
