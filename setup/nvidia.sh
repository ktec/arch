#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

read -p "Would you like to use NVIDIA stuff [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then

# Check sudo priviledges
if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you dont have the power to do this!"
	exit 1
fi

pacman -S --noconfirm nvidia

echo "Update bootloader"
sed -i '/^options/s/$/\ nvidia-drm\ modeset=1/' /boot/loader/entries/arch.conf

echo "Update intramfs"
sed -i '/^MODULES/s/)$/\ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "Create a blacklist file to prevent nouveau drivers from loading at boot"
cat /etc/modprobe.d/nouveau.conf <<FILE
blacklist nouveau
options nouveau modeset=0
FILE

echo "To update initramfs after an NVIDIA driver upgrade, lets set a pacman hook"
mkdir -p /etc/pacman.d/hooks
cat > /etc/pacman.d/hooks/nvidia.hook <<FILE
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
FILE

cat > /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf <<FILE
Section "OutputClass"
    Identifier    "nvidia"
    MatchDriver	 "nvidia-drm"
    Driver       "nvidia"
    VendorName   "NVIDIA Corporation"
    Option       "AllowEmptyInitialConfiguration"
    ModulePath   "/usr/lib/nvidia/xorg"
    ModulePath   "/usr/lib/xorg/modules"
EndSection
FILE

fi
