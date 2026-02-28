#!/usr/bin/env bash

set -e
stty -echoctl # hide ^C

# Find the USB port for the Sony ILX-LR1 camera
PORT=$(gphoto2 --auto-detect 2>/dev/null | grep -E "USB PTP Class Camera" | awk '{print $NF}')
if [ -z "$PORT" ]; then
    echo "Error: Sony ILX-LR1 camera not detected"
    exit 1
fi
echo "Found camera at port: $PORT"

on_exit() {
    sudo modprobe -r v4l2loopback
}

trap 'on_exit' EXIT
trap 'on_exit' SIGINT

sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
gphoto2 --port="$PORT" --stdout --capture-movie | ffmpeg -analyzeduration 10M -probesize 10M -f mjpeg -i - -vaapi_device /dev/dri/renderD128 -vf "hwupload,scale_vaapi=1024:680,hwdownload,format=yuv420p" -f v4l2 /dev/video0
