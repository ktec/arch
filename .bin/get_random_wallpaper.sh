#!/bin/bash

FILE=wallpaper-2880x1800-`date '+%Y_%m_%d-%H%M%S'`.jpg
SOURCE=/usr/share/wallpapers/$FILE
curl -o $SOURCE https://picsum.photos/2880/1800
