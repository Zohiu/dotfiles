#!/bin/bash

# Get newest version from git
echo "Downloading newest version..."
start_dir=$(pwd)
cd ~/config
git pull
cd $start_dir 

echo -ne "${NO_FORMAT}Press enter to start ${RSET}"
read -s

source ~/config/scripts/update-system.sh
run_update
echo -ne "${NO_FORMAT}Press enter to close ${RSET}"
read -s
echo
