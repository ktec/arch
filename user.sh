#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# ------------------------------------------------------
# All code here is run as "$USER"
# ------------------------------------------------------

echo "Install PackageQuery, Yourt and Broadcom-Wl"
cd /tmp
git clone https://aur.archlinux.org/package-query.git
pushd package-query
makepkg -si --noconfirm
popd

git clone https://aur.archlinux.org/yaourt.git
pushd yaourt
makepkg -si --noconfirm
popd

git clone https://aur.archlinux.org/broadcom-wl.git
pushd broadcom-wl
makepkg -si --noconfirm
popd

read -p "Would you like to setup an SSH key [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd && mkdir .ssh && chmod 700 .ssh
  ssh-keygen -t ed25519
  eval "$(ssh-agent -s)"
  ssh-add
fi

# DOTFILES
read -p "Would you like to install dotfiles [y/N]? " -n 1
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

read -p "Would you like to install the Slimjet Browser [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Please enble Multilib in pacman conf:"
  sudo vim /etc/pacman.conf
  sudo pacman -Syu
  echo "Install extra/atk (2) and multilib/lib32-atk (10)"
  yaourt -S lib32-atk
  echo "install slimjet dependencies"
  yaourt -S alsa-lib desktop-file-utils flac gconf gtk2 harfbuzz \
  harfbuzz-icu harfbuzz-icon-theme icu libpng libxss libxtst nss openssl nspr \
  opus snappy speech-dispatcher ttf-font xdg-utils
  echo "install slimjet"
  yaourt -G slimjet
  pushd slimjet
  # TODO: need to skip checksums for now...
  makepkg -si --noconfirm --skipchecksums
  popd
fi

read -p "Would you like to install some nice utilities [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  yaourt -S --noconfirm ttf-monaco \
    networkmanager-dmenu-git \
    urxvt-resize-font-git \
    kbdlight \
    lxappearance \
    compton \
    betterlockscreen \
    gedit \
    nautilus \
    ranger \
    w3m \
    rsync \
    unzip \
    the_silver_searcher \
    wx \
    inotify-tools \
    ttf-dejavu \
    sshfs \
    unzip
fi

read -p "Would you like to install a theme [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  yaourt -S --noconfirm \
    osx-arc-darker \
    osx-arc-shadow \
    arc-osx-icon-theme \
    moka-icon-theme-git
fi

read -p "Would you like to install asdf [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
fi

read -p "Would you like to install postgres [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yaourt -S --noconfirm postgresql
    systemctl enable postgresql.service
    sudo -u postgres initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
    systemctl start postgresql.service
    sudo -u postgres createuser --interactive
fi
# ------------------------------------------------------
# END USER SETUP
# ------------------------------------------------------
