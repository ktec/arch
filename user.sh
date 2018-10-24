#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

echo "Install PackageQuery"
cd /tmp
git clone https://aur.archlinux.org/package-query.git
pushd package-query
makepkg -si --noconfirm
popd

echo "Install Aurman"
cd /tmp
git clone https://aur.archlinux.org/aurman.git
pushd aurman
gpg --search-keys 465022E743D71E39 # don't ask!
makepkg -si --noconfirm
popd

echo "Install Broadcom-Wl"
aurman -S --noconfirm broadcom-wl

read -p "Would you like to install some os utilities [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm compton
    aurman -S --noconfirm lxappearance
    aurman -S --noconfirm gtk2
    aurman -S --noconfirm gtk3
    aurman -S --noconfirm wxgtk
    aurman -S --noconfirm wxgtk3
    aurman -S --noconfirm network-manager-applet
    aurman -S --noconfirm networkmanager-dmenu-git
    aurman -S --noconfirm dunst
    aurman -S --noconfirm inotify-tools
    aurman -S --noconfirm ttf-dejavu
#    aurman -S --noconfirm urxvt-resize-font-git
    aurman -S --noconfirm urxvt-font-size-git
    aurman -S --noconfirm the_silver_searcher
#    aurman -S --noconfirm nautilus
    aurman -S --noconfirm gnome-calculator
    aurman -S --noconfirm thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman
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
    aurman -S --noconfirm gvfs gvfs-nfs gvfs-smb
    aurman -S --noconfirm gnome-keyring libsecret
fi

read -p "Would you like to install tools and drivers for monitoring temperatures, voltage, and fans? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm lm-sensors
    aurman -S --noconfirm xfce4-sensors-plugin
    echo """
    Check out https://wiki.archlinux.org/index.php/lm_sensors for more details...
    """
fi

read -p "Would you like to install printing stuff? [y/N]? " -n 1
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

read -p "Would you like to setup a new SSH key [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    pushd $HOME
    mkdir .ssh && chmod 700 .ssh
    ssh-keygen -t ed25519
    eval "$(ssh-agent -s)"
    ssh-add
    popd
fi

read -p "Would you like to install ktec dotfiles [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    pushd $HOME
    echo "Setting up dotfiles. This should move to a dotfiles.git repo..."
    git clone -b arch --bare https://github.com/ktec/dotfiles.git .git
    git config core.bare false
    git remote remove origin
    git remote add -f origin https://github.com/ktec/dotfiles.git
    git fetch -p && git reset --hard origin/arch
    source ~/.bashrc
    popd
fi

read -p "Would you like to install asdf [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    pushd $HOME
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
    popd
fi

read -p "Would you like to install some helpful installer scripts [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  mkdir $HOME/setup
  pushd $HOME/setup
  curl -O https://raw.githubusercontent.com/ktec/arch/master/setup/apps.sh
  curl -O https://raw.githubusercontent.com/ktec/arch/master/setup/theme.sh
  curl -O https://raw.githubusercontent.com/ktec/arch/master/setup/nvidia.sh
  chmod +x *.sh
  popd
fi
