#!/bin/bash

# command info
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
 echo "script to run re-index if the blockchain - blocks will not be deleted but re-indexed"
 echo "will trigger reboot after started and progress can be monitored thru normal sync status"
 echo "network.reindex.sh reindex [mainnet|testnet|signet] --> use to start re-index chain"
 exit 1
fi

source /mnt/hdd/raspiblitz.conf

###################
# START
###################
if [ "$1" = "reindex" ]; then

  # network prefixes
  if [ "$2" = "mainnet" ]; then
    echo "# network.reindex.sh reindex --> mainnet"
    prefix=""
    netparam=""
  elif [ "$2" = "testnet" ]; then
    echo "# network.reindex.sh reindex --> testnet"
    prefix="t"
    netparam="-testnet "
  elif [ "$2" = "signet" ]; then
    echo "# network.reindex.sh reindex --> signet"
    prefix="s"
    netparam="-signet "
  else
    echo "error='unknown/missing secondary parameter'"
    exit 1
  fi

  # stop bitcoin service
  echo "# stopping ${network} service (please wait - can take time) .."
  sudo systemctl stop ${prefix}${network}d

  # starting reindex
  echo "# starting ${network} service with -reindex flag"
  sudo -u bitcoin /usr/local/bin/${network}d ${netparam}-daemon -reindex -conf=/mnt/hdd/${network}/${network}.conf -datadir=/mnt/hdd/${network} 1>&2
  echo "# waiting 10 secs"
  sleep 10
  echo "# going into reboot - reindex process can be monitored like normal blockchain sync status"
  sudo /home/admin/config.scripts/blitz.shutdown.sh reboot

  exit 0
fi

echo "error='unknown main parameter'"
exit 1

