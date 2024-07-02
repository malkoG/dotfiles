#!/usr/bin/env sh

NET_WIFI=􀙇
NET_HOTSPOT=􀉤
NET_DISCONNECTED=􀙈
NET_USB=􀉤
NET_THUNDERBOLT=􀋦
NET_OFF=􀙈

FG1=0xff98bb6c
FG2=0xff9cabca

# When switching between devices, it's possible to get hit with multiple
# concurrent events, some of which may occur before `scutil` picks up the
# changes, resulting in race conditions.
sleep 1

services=$(networksetup -listnetworkserviceorder)
device=$(scutil --nwi | sed -n "s/.*Network interfaces: \([^,]*\).*/\1/p")
IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)

test -n "$device" && service=$(echo "$services" \
  | sed -n "s/.*Hardware Port: \([^,]*\), Device: $device.*/\1/p")

color=$FG1
label=$IP_ADDRESS
case $service in
  "iPhone USB")         icon=$NET_USB;;
  "Thunderbolt Bridge") icon=$NET_THUNDERBOLT;;

  Wi-Fi)
    ssid=$(networksetup -getairportnetwork "$device" \
      | sed -n "s/Current Wi-Fi Network: \(.*\)/\1/p")
    case $ssid in
      *iPhone*) icon=$NET_HOTSPOT;;
      "")       icon=$NET_DISCONNECTED; color=$FG2; label="--";;
      *)        icon=$NET_WIFI;;
    esac;;

  *)
    wifi_device=$(echo "$services" \
      | sed -n "s/.*Hardware Port: Wi-Fi, Device: \([^\)]*\).*/\1/p")
    test -n "$wifi_device" && status=$( \
      networksetup -getairportpower "$wifi_device" | awk '{print $NF}')
    icon=$(test "$status" = On && echo "$NET_DISCONNECTED" || echo "$NET_OFF")
    color=$FG2
    label="--------"
    ;;
esac

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="$label"

