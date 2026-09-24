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

# X runs on the Intel GPU; nvidia is only used for compute (CUDA/ollama).
# Keep nvidia OUT of the initramfs: loaded there it refuses to freeze on
# hibernate resume ("resume failed (-5)"). And no nvidia-drm option on the
# kernel command line: module options need a dot, modprobe.d is the place.
echo "Disable nvidia-drm modesetting"
cat > /etc/modprobe.d/nvidia.conf <<FILE
options nvidia-drm modeset=0
FILE

# Let the idle GPU power off (runtime D3). The driver only does this by
# itself on Ampere and newer; Turing (GTX 1650 Ti) needs 0x02. Measured on
# battery: 13.4 W -> 9.5 W idle. Anything holding /dev/nvidia* (e.g. ollama)
# keeps it awake, so start such services on demand.
echo "Enable NVIDIA runtime power management"
cat > /etc/modprobe.d/nvidia-pm.conf <<FILE
options nvidia "NVreg_DynamicPowerManagement=0x02"
FILE
cat > /etc/udev/rules.d/80-nvidia-pm.rules <<'FILE'
# Enable runtime PM for NVIDIA VGA/3D controllers on driver bind, disable on unbind
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
FILE

echo "Create a blacklist file to prevent nouveau drivers from loading at boot"
cat > /etc/modprobe.d/nouveau.conf <<FILE
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

echo "Drive the display from the Intel GPU"
cat > /etc/X11/xorg.conf.d/10-intel-primary.conf <<FILE
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "modesetting"
    BusID       "PCI:0:2:0"
    Option      "TearFree" "true"
EndSection
FILE

fi
