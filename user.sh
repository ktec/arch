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
    APPS=(
        compton
        ctags
        dunst
        bash-completion
        file-roller
        gnome-calculator
        gnome-keyring libsecret seahorse
        gparted exfat-utils ntfs-3g udftools nilfs-utils gpart mtools
        gtk2
        gtk3
        gvfs gvfs-nfs gvfs-smb
        inotify-tools
        iotop
        lxappearance
        network-manager-applet
        networkmanager-dmenu-git
        nfs-utils
        ranger
        rofi
        rsync
        screenfetch
        sshfs
        the_silver_searcher
        thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman
        tree
        ttf-dejavu
        udisks2 udiskie
        unzip
        urxvt-font-size-git
        w3m
        wxgtk
        wxgtk3
        xsane
    )

#   nautilus
#   urxvt-resize-font-git

    for app in "${APPS[@]}"
    do
        yay -S --noconfirm $app
    done
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
