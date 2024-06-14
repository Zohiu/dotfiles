#!/bin/bash

echo "Installing..."
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mv $SCRIPT_DIR ~/config
echo "Installed! Please remember to change ~/config/scripts/variables.sh to your needs."

source ~/config/scripts/update-config.sh
run_update


