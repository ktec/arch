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
cd /tmp
git clone https://aur.archlinux.org/broadcom-wl.git
pushd broadcom-wl
makepkg -si --noconfirm
popd
