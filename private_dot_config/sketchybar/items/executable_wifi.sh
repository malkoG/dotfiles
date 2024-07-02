#!/bin/bash

sketchybar --add item net right                  \
           --set net script="$PLUGIN_DIR/wifi.sh" \
                     updates=on                  \
                     padding_right=0             \
                     icon.padding_right=6        \
           --subscribe net wifi_change
