# LXC Chef Prep

This turns a base LXC debian install into something suitable for running knife bootstrap on.

* Creates a chefdeploy user
* Sets up wheel as a NOPASSWD sudo group (sudo still exists as a PASSWD sudo group)
* Adds a specified ssh key to the group
* Installs chef

# Requirements

* An already created Debian LXC container with networking enabled
* Tested with jessie
* The ssh key you want to use in a file named "ssh_key.pub"
* DNS container resolution on host.  lxc-net and using dnsmasq as a caching resolver should be good enough. http://bryanalves.github.io/2015/07/03/lxc-dns-on-host/

# Quick start

    sudo lxc-create -t debian --name test01

    # Set up networking, Example:
    echo lxc.network.type = veth >> /var/lib/lxc/test01/config
    echo lxc.network.flags = up >> /var/lib/lxc/test01/config
    echo lxc.network.link = lxcbr0 >> /var/lib/lxc/test01/config

    ./lxc-chef-setup.sh test01

    # Wait a few minutes for completion. then:

    knife bootstrap test01 -x chefdeploy --sudo -N test01
