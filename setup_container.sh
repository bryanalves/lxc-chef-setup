#!/bin/sh

if [ ! -f ssh_key.pub ]; then
    echo "ssh key missing.  Please put the deploy ssh key in ssh_key.pub"
    exit 1
fi

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

CONTAINER=$1
PLATFORM=$2

if [ -z $PLATFORM ]; then
    echo "platform not specified"
    exit 1
fi

lxc-start -n $CONTAINER 2> /dev/null

## Init
<container/init.sh lxc-attach -n $CONTAINER -- \
    /bin/sh -c "/bin/cat > /root/init.sh ; /bin/chmod +x /root/init.sh"

lxc-attach -n $CONTAINER --clear-env -- /root/init.sh

## Platform specific
<container/$PLATFORM-setup.sh lxc-attach -n $CONTAINER -- \
    /bin/sh -c "/bin/cat > /root/chef-setup.sh ; /bin/chmod +x /root/chef-setup.sh"

lxc-attach -n $CONTAINER --clear-env -- /root/chef-setup.sh

## Common setup
<container/common-setup.sh lxc-attach -n $CONTAINER -- \
    /bin/sh -c "/bin/cat > /root/common-setup.sh ; /bin/chmod +x /root/common-setup.sh"

lxc-attach -n $CONTAINER --clear-env -- /root/common-setup.sh

<ssh_key.pub lxc-attach -n $CONTAINER --clear-env -- \
    /bin/sh -c "/bin/cat >> /home/chefdeploy/.ssh/authorized_keys"
