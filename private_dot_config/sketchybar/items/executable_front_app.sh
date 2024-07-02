#!/bin/bash

sketchybar --add item front_app left \
           --set front_app icon.color=$ACCENT_COLOR \
                                 icon.font="sketchybar-app-font:Regular:16.0" \
                                 label.color=$BRACKET_COLOR \
                                 background.color=$BRACKET_COLOR \
                                 icon.y_offset=-1 \
                                 padding_left=0 \
                                 label.padding_right=0 \
                                 label.padding_left=0 \
                                 icon.padding_right=4 \
                                 icon.padding_left=4 \
                                 script="$PLUGIN_DIR/front_app.sh"            \
           --subscribe front_app front_app_switched
