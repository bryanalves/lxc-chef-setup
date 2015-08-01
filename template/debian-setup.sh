#!/bin/sh

TEMPLATE_DIR=$1

chef_ver=chef_12.4.1-1

chroot $TEMPLATE_DIR apt-get install --force-yes -fuy sudo wget
wget "https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/${chef_ver}_amd64.deb" -O $TEMPLATE_DIR/root/${chef_ver}_amd64.deb

chroot $TEMPLATE_DIR dpkg -i /root/${chef_ver}_amd64.deb
