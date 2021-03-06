#!/usr/bin/env bash

i3status -c ~/.i3/i3status.conf | while :
do
    read line
    pomodoro=`python ~/src/i3-gnome-pomodoro/pomodoro-client.py status`
    echo "$pomodoro| $line" || exit 1
done
