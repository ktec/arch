#!/bin/bash

SOURCE=`find /usr/share/wallpapers/ -type f | shuf -n1`
LINK=.local/share/wallpaper.jpg

[[ -f $LINK ]] && rm -rf $LINK
ln -s $SOURCE $LINK
