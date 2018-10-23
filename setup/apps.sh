#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

read -p "Would you like to install the Slimjet Browser [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please enble Multilib in pacman conf:"
    sudo vim /etc/pacman.conf
    sudo pacman -Syu
    echo "Install extra/atk (2) and multilib/lib32-atk (10)"
    aurman -S lib32-atk
    echo "install slimjet dependencies"
    aurman -S alsa-lib desktop-file-utils flac gconf gtk2 harfbuzz \
    harfbuzz-icu harfbuzz-icon-theme icu libpng libxss libxtst nss openssl nspr \
    opus snappy speech-dispatcher ttf-font xdg-utils
    echo "install slimjet"
    aurman -G slimjet
    pushd slimjet
    # TODO: need to skip checksums for now...
    makepkg -si --noconfirm --skipchecksums
    popd
fi

read -p "Would you like to install some multimedia stuff [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    aurman -S --noconfirm mplayer
    aurman -S --noconfirm vlc
fi

read -p "Would you like to install some useful apps [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    aurman -S --noconfirm gedit
    aurman -S --noconfirm krita
    aurman -S --noconfirm libreoffice
    aurman -S --noconfirm darktable
    aurman -S --noconfirm lightzone
    aurman -S --noconfirm gimp
fi
