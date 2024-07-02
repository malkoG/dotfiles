#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=􀉉 \
                          update_freq=20 \
                          script="$PLUGIN_DIR/calendar.sh" \
                          padding_right=12 \                                                         background.color=0xff9cabca \
                          label.color=$DARK_BG \
                          icon.color=$DARK_BG \
