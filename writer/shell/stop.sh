#!/bin/bash
source params.sh

if [ -f $ME/nodeos.pid ]; then
  kill -INT `cat $ME/nodeos.pid` > /dev/null 2>&1
  rm -f $ME/nodeos.pid
fi

