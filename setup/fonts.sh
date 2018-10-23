#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

read -p "Would you like to install some fonts [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aurman -S --noconfirm ttf-monaco
    aurman -S --noconfirm ttf-dejavu
    aurman -S --noconfirm ttf-google-fonts-git
    aurman -S --noconfirm ttf-liberation
    aurman -S --noconfirm ttf-meslo
    aurman -S --noconfirm ttf-font-awesome
    aurman -S --noconfirm ttf-liberation noto-fonts
    aurman -S --noconfirm adobe-source-code-pro-fonts
fi
