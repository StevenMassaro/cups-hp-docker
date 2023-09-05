#!/bin/bash -ex

# start cupsd and run it detached from the current console
/usr/sbin/cupsd

# install the new printer (this needs cupsd running)
expect ./install-printer.exp

# kill cupsd
pkill cupsd

/entrypoint.sh