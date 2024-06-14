#!/bin/bash

SOURCE_DIR=~/config

# profile
cp $SOURCE_DIR/fish_profile ~/.fish_profile

# configs
cp -rd $SOURCE_DIR/configs/. ~/.config

# This will fail when first installing and that's fine.
pkill waybar
swaymsg reload
