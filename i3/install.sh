#~/bin/sh
ROOTDIR=`pwd`

yaourt -Sy --needed \
    i3 \
    dmenu \
    feh \
    ranger \
    xorg-xrandr \
    arandr

ln -s $ROOTDIR ~/.i3
