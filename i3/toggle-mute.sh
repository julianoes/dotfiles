#!/bin/sh
# credits: http://blog.bstpierre.org/controlling-audio-with-i3
toggle=$((pactl list sinks | grep -q Mute:.no && echo 1) || echo 0)
pactl set-sink-mute 0 $toggle
