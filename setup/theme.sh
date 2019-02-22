#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# This needs to run inside i3
read -p "Would you like to set a desktop wallpaper [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  aurman -S --noconfirm feh
  DIMENSIONS=$(xdpyinfo | awk '/dimensions/{print $2}')
  mkdir -p ~/Pictures
  curl https://source.unsplash.com/random/$DIMENSIONS -o ~/Pictures/wallpaper.jpg
fi

read -p "Would you like to install some themes [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm osx-arc-darker
    aurman -S --noconfirm osx-arc-shadow
    aurman -S --noconfirm arc-osx-icon-theme
    aurman -S --noconfirm moka-icon-theme-git
    # based on Paper Icon Set and Papirus
    aurman -S --noconfirm papirus-icon-theme
    aurman -S --noconfirm papirus-libreoffice-theme
    # based
    aurman -S --noconfirm adapta-gtk-theme
    # A modified version of the Numix GTK
    aurman -S --noconfirm numix-gtk-theme-git
    # GNOME's Adwaita Theme
    aurman -S --noconfirm adwaita-icon-theme adwaita-qt5 adwaita-qt4 adg-gtk-theme adwaita-dark adwaita-xfce-theme-git firefox-theme-gnome-git
fi

read -p "Would you like to install some fonts [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm ttf-monaco
    aurman -S --noconfirm ttf-dejavu
    aurman -S --noconfirm ttf-google-fonts-git
    aurman -S --noconfirm ttf-liberation
    aurman -S --noconfirm ttf-meslo
    aurman -S --noconfirm ttf-font-awesome
    aurman -S --noconfirm ttf-liberation noto-fonts
    aurman -S --noconfirm adobe-source-code-pro-fonts
fi
