#!/bin/bash

echo "Installing..."
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $SCRIPT_DIR != ~/config ]; then
    mv $SCRIPT_DIR ~/config
fi

sudo chmod +x ~/config/update.sh
sudo chmod +x ~/config/scripts/*

echo "Installed! Running update..."

source ~/config/scripts/update-system.sh
run_update

