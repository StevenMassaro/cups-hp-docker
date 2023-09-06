#!/bin/bash -ex

# start cupsd and run it detached from the current console
/usr/sbin/cupsd

sleep 5s

# install the new printer (this needs cupsd running)
expect ./install-printer.exp

sleep 5s

# kill cupsd
pkill cupsd

sleep 5s

/entrypoint.sh