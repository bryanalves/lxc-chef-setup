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

function lxc_attach_exec {
    CONTAINER=$1
    SCRIPT=$2

    <container/$SCRIPT lxc-attach -n $CONTAINER -- \
        /bin/sh -c "/bin/cat > /root/$SCRIPT ; /bin/chmod +x /root/$SCRIPT"

    lxc-attach -n $CONTAINER --clear-env -- /root/$SCRIPT
    lxc-attach -n $CONTAINER --clear-env -- rm /root/$SCRIPT
}

lxc-start -n $CONTAINER 2> /dev/null

lxc_attach_exec $CONTAINER init.sh
lxc_attach_exec $CONTAINER $PLATFORM-setup.sh
lxc_attach_exec $CONTAINER common-setup.sh

<ssh_key.pub lxc-attach -n $CONTAINER --clear-env -- \
    /bin/sh -c "/bin/cat >> /home/chefdeploy/.ssh/authorized_keys"
