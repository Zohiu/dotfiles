#!/bin/bash

# Get newest version from git
echo "Downloading newest version..."
start_dir=$(pwd)
cd ~/config
git pull
cd $start_dir 

source ~/config/scripts/update-system.sh
run_update
