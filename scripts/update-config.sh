#!/bin/bash

SOURCE_DIR=~/config

# profile
cp $SOURCE_DIR/fish_profile ~/.fish_profile

# configs
cp -rd $SOURCE_DIR/configs/. ~/.config

# This is only executed when reloading sway
if [[ "$(pwd)" != "$SOURCE_DIR" ]]; then
    pkill waybar
    swaymsg reload
fi
