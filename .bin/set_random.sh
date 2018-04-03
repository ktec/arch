#!/bin/bash

SOURCE=`find /usr/share/wallpapers/ -type f | shuf -n1`
LINK=/usr/share/wallpapers/wallpaper.jpg

[[ -f $LINK ]] && rm -rf $LINK
ln -s $SOURCE $LINK
