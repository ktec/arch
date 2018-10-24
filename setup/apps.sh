#!/bin/bash
# Copyright (c) 2018 Keith Salisbury


echo "Install Yay"
cd /tmp
git clone https://aur.archlinux.org/yay.git
pushd yay
makepkg -si --noconfirm
popd

read -p "Would you like to install the Slimjet Browser [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please enble Multilib in pacman conf: (search for multi and uncomment)"
    sudo vim /etc/pacman.conf
    sudo pacman -Syu
    echo "Install extra/atk (2) and multilib/lib32-atk (10)"
    yay -S lib32-atk
    echo "install slimjet dependencies"
    yay -S alsa-lib desktop-file-utils flac gconf harfbuzz \
    harfbuzz-icu harfbuzz-icon-theme icu libpng libxss libxtst nss openssl nspr \
    opus snappy speech-dispatcher ttf-font xdg-utils
    echo "install slimjet"
    yay -S slimjet
    pushd slimjet
    # TODO: need to skip checksums for now...
    makepkg -si --noconfirm --skipchecksums
    popd
fi

read -p "Would you like to install some multimedia stuff [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    yay -S --mflags "--noconfirm" mplayer
    yay -S --mflags "--noconfirm" vlc
    yay -S --mflags "--noconfirm" ncmpcpp
fi

read -p "Would you like to install postgres [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --mflags "--noconfirm" postgresql
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
    sudo pacman -S --needed base-devel
    yay -S --mflags "--noconfirm" glu mesa wxgtk2 libpng
    yay -S --mflags "--noconfirm" curses fop libxslt libssh erlang-unixodbc
    export KERL_CONFIGURE_OPTIONS="--enable-compat28"
    export KERL_BUILD_DOCS="yes"
    #javac

    asdf plugin-list-all
    asdf plugin-add erlang
    asdf install erlang 21.1.1
fi

read -p "Would you like to install some useful apps [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    yay -S --mflags "--noconfirm" hunspell hunspell-en_GB
    yay -S --mflags "--noconfirm" atom
    yay -S --mflags "--noconfirm" gedit
    yay -S --mflags "--noconfirm" krita
    yay -S --mflags "--noconfirm" libreoffice
    yay -S --mflags "--noconfirm" darktable
    yay -S --mflags "--noconfirm" lightzone
    yay -S --mflags "--noconfirm" gimp
fi

read -p "Would you like to install co working tools [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  yay -S --mflags "--noconfirm" x11vnc tk net-tools
  yay -S --mflags "--noconfirm" remmina
fi
