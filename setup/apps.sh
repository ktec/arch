#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

read -p "Would you like to install the Slimjet Browser [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please enble Multilib in pacman conf: (search for multi and uncomment)"
    sudo vim /etc/pacman.conf
    sudo pacman -Syu
    echo "Install extra/atk (2) and multilib/lib32-atk (10)"
    aurman -S lib32-atk
    echo "install slimjet dependencies"
    aurman -S alsa-lib desktop-file-utils flac gconf harfbuzz \
    harfbuzz-icu harfbuzz-icon-theme icu libpng libxss libxtst nss openssl nspr \
    opus snappy speech-dispatcher ttf-font xdg-utils
    echo "install slimjet"
    aurman -S slimjet
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
    aurman -S --noconfirm ncmpcpp
fi

read -p "Would you like to install postgres [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm postgresql
    systemctl enable postgresql.service
    sudo -u postgres initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
    systemctl start postgresql.service
    echo
    echo "Now you can set up a postgres user:"
    echo
    sudo -u postgres createuser --interactive
fi

read -p "Would you like to install dependencies for erlang? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    export KERL_CONFIGURE_OPTIONS="--enable-compat28"
    #javac
    #odbc
    #xsltproc
    #fop

    asdf plugin-list-all
    asdf plugin-add erlang
    asdf install erlang 21.1.1
fi

read -p "Would you like to install some useful apps [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    aurman -S --noconfirm atom
    aurman -S --noconfirm gedit
    aurman -S --noconfirm krita
    aurman -S --noconfirm libreoffice
    aurman -S --noconfirm darktable
    aurman -S --noconfirm lightzone
    aurman -S --noconfirm gimp
fi
