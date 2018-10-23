#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# This needs to run inside i3
read -p "Would you like to set a desktop wallpaper [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -S --noconfirm feh
  DIMENSIONS=$(xdpyinfo | awk '/dimensions/{print $2}')
  mkdir -p ~/Pictures
  curl https://source.unsplash.com/random/$DIMENSIONS -o ~/Pictures/wallpaper.jpg
fi

read -p "Would you like to install some os utilities [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm compton
    aurman -S --noconfirm lxappearance
    aurman -S --noconfirm network-manager-applet
    aurman -S --noconfirm networkmanager-dmenu-git
    aurman -S --noconfirm dunst
    aurman -S --noconfirm inotify-tools
    aurman -S --noconfirm urxvt-resize-font-git
    aurman -S --noconfirm the_silver_searcher
#    aurman -S --noconfirm nautilus
    aurman -S --noconfirm gnome-calculator
    aurman -S --noconfirm thunar
    aurman -S --noconfirm ranger
    aurman -S --noconfirm w3m
    aurman -S --noconfirm rsync
    aurman -S --noconfirm unzip
    aurman -S --noconfirm sshfs
    aurman -S --noconfirm xsane
    aurman -S --noconfirm iotop
    aurman -S --noconfirm rofi
    aurman -S --noconfirm tree
    aurman -S --noconfirm gparted exfat-utils ntfs-3g udftools nilfs-utils gpart mtools
    aurman -S --noconfirm gvfs
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

read -p "Would you like to install tools and drivers for monitoring temperatures, voltage, and fans? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # tools and drivers for monitoring temperatures, voltage, and fans.
    aurman -S --noconfirm lm-sensors
    aurman -S --noconfirm xfce4-sensors-plugin
    echo """
    Check out https://wiki.archlinux.org/index.php/lm_sensors for more details...
    """
fi

read -p "Would you like to install tools and drivers for monitoring temperatures, voltage, and fans? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm canon-pixma-mg5500-complete
    aurman -S --noconfirm ghostscript
fi

read -p "Would you like to install pulseaudio stuff? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm pulseaudio-alsa
    aurman -S --noconfirm pulseaudio-bluetooth
fi
