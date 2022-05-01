#!/bin/bash

PATH=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")
echo $PATH

source "$PATH/global.sh"


#? setting time
log_start 'SET TIME'
timedatectl set-ntp true &> /dev/null