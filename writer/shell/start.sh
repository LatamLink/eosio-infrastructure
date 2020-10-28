#!/bin/bash
source params.sh
if [ ! -d $LOGS_DIR ]; then
    mkdir $LOGS_DIR;
fi

if [  -e $ME/nodeos.pid ]; then
   echo "an instance of nodeo is already running"
   exit 0
fi

echo "DATA DIR $DATA_DIR"
echo "CONFIG  DIR $CONFIG_DIR"
echo "extra args $EXTRA_ARGS"
ulimit -s 64000
nodeos --data-dir $DATA_DIR --config-dir $CONFIG_DIR $EXTRA_ARGS "$@" >> $LOG_FILE 2>&1 &
echo $! > $ME/nodeos.pid


