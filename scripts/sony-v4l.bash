#!/usr/bin/env bash

set -e
stty -echoctl # hide ^C

on_exit() {
    sudo modprobe -r v4l2loopback
}

trap 'on_exit' EXIT
trap 'on_exit' SIGINT

sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
#gphoto2 --stdout --set-config liveviewsize=0 --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 8 -f v4l2 /dev/video0
#gphoto2 --camera="Sony ILCE-7C (Control)" --set-config liveviewsize=0 --set-config /main/actions/movie=1 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 8 -f v4l2 /dev/video0
#gphoto2 --camera="Sony ILCE-7C (Control)" --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
#gphoto2 --camera="Sony ILCE-7C (Control)" --stdout --capture-movie | ffmpeg -f rawvideo -pix_fmt yuv420p -i - -vaapi_device /dev/dri/renderD128 -vf "hwupload" -c:v h264_vaapi -f v4l2 /dev/video0
gphoto2 --camera="Sony ILCE-7C (Control)" --stdout --capture-movie | ffmpeg -f mjpeg -i - -vaapi_device /dev/dri/renderD128 -vf "hwupload,scale_vaapi=1024:576,hwdownload,format=yuv420p" -f v4l2 /dev/video0
