#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

echo "Install PackageQuery"
cd /tmp
git clone https://aur.archlinux.org/package-query.git
pushd package-query
makepkg -si --noconfirm
popd

echo "Install Yay"
cd /tmp
git clone https://aur.archlinux.org/yay.git
pushd yay
makepkg -si --noconfirm
popd

echo "Install Broadcom-Wl"
yay -S --noconfirm broadcom-wl

read -p "Would you like to install some os utilities [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --noconfirm compton
    yay -S --noconfirm ctags
    yay -S --noconfirm dunst
    yay -S --noconfirm file-roller
    yay -S --noconfirm gnome-calculator
    yay -S --noconfirm gnome-keyring libsecret seahorse
    yay -S --noconfirm gparted exfat-utils ntfs-3g udftools nilfs-utils gpart mtools
    yay -S --noconfirm gtk2
    yay -S --noconfirm gtk3
    yay -S --noconfirm gvfs gvfs-nfs gvfs-smb
    yay -S --noconfirm inotify-tools
    yay -S --noconfirm iotop
    yay -S --noconfirm lxappearance
    yay -S --noconfirm network-manager-applet
    yay -S --noconfirm networkmanager-dmenu-git
    yay -S --noconfirm nfs-utils
    yay -S --noconfirm ranger
    yay -S --noconfirm rofi
    yay -S --noconfirm rsync
    yay -S --noconfirm screenfetch
    yay -S --noconfirm sshfs
    yay -S --noconfirm the_silver_searcher
    yay -S --noconfirm thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman
    yay -S --noconfirm tree
    yay -S --noconfirm ttf-dejavu
    yay -S --noconfirm udisks2 udiskie
    yay -S --noconfirm unzip
    yay -S --noconfirm urxvt-font-size-git
    yay -S --noconfirm w3m
    yay -S --noconfirm wxgtk
    yay -S --noconfirm wxgtk3
    yay -S --noconfirm xsane
#    yay -S --noconfirm nautilus
#    yay -S --noconfirm urxvt-resize-font-git
fi

read -p "Would you like to install tools and drivers for monitoring temperatures, voltage, and fans? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --noconfirm lm-sensors
    yay -S --noconfirm xfce4-sensors-plugin
    echo """
    Check out https://wiki.archlinux.org/index.php/lm_sensors for more details...
    """
fi

read -p "Would you like to install printing stuff? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --noconfirm canon-pixma-mg5500-complete
    yay -S --noconfirm ghostscript
    yay -S --noconfirm simple-scan
fi

read -p "Would you like to install pulseaudio stuff? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --noconfirm pulseaudio-alsa
    yay -S --noconfirm pulseaudio-bluetooth
    yay -S --noconfirm pavucontrol
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


read -p "Would you like to install android stuff [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm android-tools
    aurman -S --noconfirm android-udev
fi
