#!/bin/sh

echo "Starting chef setup:"
hostname

echo

echo "Waiting for network"
while ! ip route | grep default > /dev/null; do
    printf .
    sleep 1
done

echo
