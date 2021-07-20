#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: ./custom-nodesuite.sh <NODESUITE_PATH>"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd ${1}
mkdir -p ./roles/deploy_node/files/lacchain/dev/

cd $SCRIPT_DIR
cp ./genesis.json "${1}/roles/deploy_node/files/lacchain/dev/genesis.json"
cp -R ./data "${1}/.private/data"

cd ${1}
python3 nodesuite_cli.py config-symlink .private/data
