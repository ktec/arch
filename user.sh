#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# ------------------------------------------------------
# All code here is run as "$USER"
# ------------------------------------------------------

echo "Install PackageQuery"
cd /tmp
git clone https://aur.archlinux.org/package-query.git
pushd package-query
makepkg -si --noconfirm
popd

echo "Install Aurman"
git clone https://aur.archlinux.org/aurman.git
pushd aurman
makepkg -si --noconfirm
popd

echo "Install Broadcom-Wl"
git clone https://aur.archlinux.org/broadcom-wl.git
pushd broadcom-wl
makepkg -si --noconfirm
popd

read -p "Would you like to setup a new SSH key [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd && mkdir .ssh && chmod 700 .ssh
    ssh-keygen -t ed25519
    eval "$(ssh-agent -s)"
    ssh-add
fi

# DOTFILES
read -p "Would you like to install ktec dotfiles [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Setting up dotfiles. This should move to a dotfiles.git repo..."
    git clone -b arch --bare https://github.com/ktec/dotfiles.git .git
    git config core.bare false
    git remote remove origin
    git remote add -f origin https://github.com/ktec/dotfiles.git
    git fetch -p && git reset --hard origin/arch
fi

read -p "Would you like to set a desktop wallpaper [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -S --noconfirm feh
  DIMENSIONS=$(xdpyinfo | awk '/dimensions/{print $2}')
  curl https://source.unsplash.com/random/$DIMENSIONS -o ~/Pictures/wallpaper.jpg
fi

read -p "Would you like to install some fonts [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm ttf-monaco
    aurman -S --noconfirm ttf-dejavu
    aurman -S --noconfirm ttf-google-fonts-git
    aurman -S --noconfirm ttf-liberation
    aurman -S --noconfirm ttf-meslo
fi

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

read -p "Would you like to install some os utilities [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm compton
    aurman -S --noconfirm lxappearance
    aurman -S --noconfirm networkmanager-dmenu-git
    aurman -S --noconfirm dunst
    aurman -S --noconfirm inotify-tools
    aurman -S --noconfirm urxvt-resize-font-git
    aurman -S --noconfirm betterlockscreen
    aurman -S --noconfirm the_silver_searcher
    aurman -S --noconfirm nautilus
    aurman -S --noconfirm thunar
    aurman -S --noconfirm ranger
    aurman -S --noconfirm w3m
    aurman -S --noconfirm rsync
    aurman -S --noconfirm unzip
    aurman -S --noconfirm sshfs
    aurman -S --noconfirm xsane
    aurman -S --noconfirm redshift
    aurman -S --noconfirm iotop
    aurman -S --noconfirm dig
    aurman -S --noconfirm rofi
    aurman -S --noconfirm tree
    aurman -S --noconfirm gparted exfat-utils ntfs-3g udftools nilfs-utils gpart mtools
    aurman -S --noconfirm gvfs
fi

read -p "Would you like to install some useful apps [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    aurman -S --noconfirm gedit
    aurman -S --noconfirm krita
    aurman -S --noconfirm libreoffice
fi

read -p "Would you like to install some multimedia stuff [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # here be some goodies
    aurman -S --noconfirm mplayer
    aurman -S --noconfirm vlc
fi


read -p "Would you like to install some themes [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm osx-arc-darker
    aurman -S --noconfirm osx-arc-shadow
    aurman -S --noconfirm arc-osx-icon-theme
    aurman -S --noconfirm moka-icon-theme-git
fi

read -p "Would you like to install asdf [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
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
    export KERL_CONFIGURE_OPTIONS="--enable-compat28"
    asdf install erlang 20.3
fi

# ------------------------------------------------------
# END USER SETUP
# ------------------------------------------------------
