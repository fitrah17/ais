#!/bin/bash

source ./global.sh

#! check for wget first
log_start ''
sudo pacman -Sy --noconfirm --needed wget 1>> /var/log/ais.out 2>> /var/log/ais.err
log_end