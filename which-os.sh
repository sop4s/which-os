#!/bin/bash

FG_BLUE="\x1b[0;34m"
FG_RED="\x1b[0;31m"
FG_RESET="\x1b[0m"

ERR="$FG_RED[Error]$FG_RESET"

function log_error() {
  echo -e "$ERR $@"
}

function check() {
  output=$(ping -c 1 "$1" 2>&1)

  if [ $? -eq 0 ]; then
    ttl_line=$(echo $output | grep -i 'ttl=')
    ttl=$(echo "$ttl_line" | awk -F 'ttl=' {'print $2'} | cut -d ' ' -f 1)
    echo -ne "TTL: $FG_BLUE$ttl$FG_RESET -> "
    

    if [[ $ttl -ge 0 && $ttl -le 64 ]]; then
      echo -e $FG_BLUE"Linux"$FG_RESET
    elif [[ $ttl -ge 64 && $ttl -le 128 ]]; then
      echo -e $FG_BLUE"Windows"$FG_RESET
    else
      echo -e $FG_RED"Unknown"$FG_RESET
    fi

  else
    log_error "pinging --> $output"
  fi
}

if [ -z "$1" ]; then
  log_error "target ip is missing"
  exit 1
fi

if [ "$EUID" -ne 0 ]; then
  log_error "user must be root"
  exit 1
fi

check $1
