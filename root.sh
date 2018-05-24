#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# ------------------------------------------------------
# All code here is run as root
# ------------------------------------------------------

echo "Lets update Arch and install the linux headers"
pacman -Syu
pacman -S linux{,-headers}

echo "Install terminus font"
pacman -S --noconfirm terminus-font # Decent terminal font
setfont ter-v32n
echo 'FONT=ter-v32n' >> /etc/vconsole.conf

echo "Setup locale"
echo 'LANG="en_GB.UTF-8"' >> /etc/locale.conf
echo 'LC_COLLATE="C"' >> /etc/locale.conf
sed -i '/#en_GB/s/^#//' /etc/locale.gen
export LC_ALL='en_GB.UTF-8'
locale-gen
# echo 'LANGUAGE'
# echo 'LC_ALL'
rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

echo "Configure keyboard"
# localectl set-keymap de-latin1-nodeadkeys
# localectl set-x11-keymap de-latin1-nodeadkeys
# https://wiki.archlinux.org/index.php/Apple_Keyboard
# tee /sys/module/hid_apple/parameters/iso_layout <<< 0
# This doesn't seem to work in our favour - fn keys stop working with it
# echo "options hid_apple fnmode=0" | tee /etc/modprobe.d/hid_apple.conf
# echo 'FILES="$FILES:/etc/modprobe.d/hid_apple.conf"' | tee -a /etc/mkinitcpio.conf

echo "Update hosts file"
cat >> /etc/hosts <<FILE
127.0.0.1     localhost.localdomain      localhost
::1           localhost.localdomain      localhost
127.0.1.1     myhostname.localdomain     myhostname
FILE

cat >> /etc/resolve.conf <<FILE
# OpenDNS IPv4 nameservers
nameserver 193.183.98.66
nameserver 51.254.25.115
nameserver 188.165.200.156
nameserver 51.255.48.78

# OpenDNS IPv6 nameservers
nameserver 2620:0:ccc::2
nameserver 2620:0:ccd::2

# Google IPv4 nameservers
nameserver 8.8.8.8
nameserver 8.8.4.4

# Google IPv6 nameservers
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844

# Comodo nameservers
nameserver 8.26.56.26
nameserver 8.20.247.20
FILE

echo "Install bootloader"
pacman -S --noconfirm intel-ucode
bootctl install
PARTUUID=$(blkid | grep sda2 | sed 's/.*PARTUUID="\(.*\)".*/PARTUUID=\1/g')
cat > /boot/loader/entries/arch.conf <<FILE
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=$PARTUUID rw quiet
FILE

echo "Install some stuff"
pacman -S --noconfirm dialog git sudo htop wget gvim acpi
# pacman -S --noconfirm nvidia
pacman -S --noconfirm xorg-server xorg-apps xorg-xinit xorg-twm xterm
pacman -S --noconfirm i3-gaps dmenu rxvt-unicode gtk2-perl i3lock i3status
pacman -S --noconfirm wpa_supplicant
pacman -S --noconfirm xbindkeys
pacman -S --noconfirm powertop
pacman -S --noconfirm keychain
# pacman -S --noconfirm autocutsel
pacman -S --noconfirm openssh
pacman -S --noconfirm acpid ntp dbus avahi cups cronie ntp
pacman -S --noconfirm python-dbus
pacman -S --noconfirm arandr
pacman -S --noconfirm wxgtk

echo "Enable system services"
systemctl enable acpid
systemctl enable ntpd
systemctl enable avahi-daemon
systemctl enable org.cups.cupsd.service

echo "Enable networking using Network Manager"
systemctl disable dhcpcd
pacman -S networkmanager network-manager-applet networkmanager-openvpn
systemctl disable dhcpcd.service
systemctl enable NetworkManager.service
nmcli dev wifi list
read -p "Would you like to connect to CleverBunny-Guest wifi [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  nmcli dev wifi connect "CleverBunny-Guest"
fi

# systemctl enable systemd-networkd
# systemctl enable systemd-resolved
# systemctl enable systemd-timesyncd

echo "Update the time"
#echo "server de.pool.ntp.org" >> /etc/ntp.conf
ntpd -gq
hwclock --systohc --utc

# echo "Disable wake from S3 on XHC1"
# cat > /etc/udev/rules.d/90-xhc_sleep.rules <<FILE
# # disable wake from S3 on XHC1
# SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
# FILE

# TODO: Investigate whether this works
# Possibly missing firmware for module: aic94xx
# Possibly missing firmware for module: wd719x
# https://gist.github.com/imrvelj/c65cd5ca7f5505a65e59204f5a3f7a6d

echo "Load powertop autotune settings at boot"
# For more effective power management it is recommended to follow
# https://wiki.archlinux.org/index.php/Power_management
cat > /etc/systemd/system/powertop.service <<FILE
[Unit]
Description=Powertop tunings

[Service]
ExecStart=/usr/bin/powertop --auto-tune
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
FILE

# Maybe we want sound?
echo "Lets get sound working"
pacman -S --noconfirm alsa-utils
echo "Here are the sound cards"
cat /proc/asound/cards
aplay -l

cat > /etc/asound.conf <<FILE
defaults.pcm.card 1
defaults.pcm.device 0
defaults.ctl.card 0
FILE

# cat > /etc/systemd/network/25-wireless.network <<FILE
# [Match]
# Name=wl*
#
# [Network]
# DHCP=ipv4
# FILE

echo "Enable natural scrolling and will setup trackpad acceleration like it is on MacOS"
cat > /etc/X11/xorg.conf.d/30-touchpad.conf <<FILE
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "ClickMethod" "clickfinger"
    Option "AccelProfile" "flat"
EndSection
FILE

echo "Enable natural scrolling for our external mouse as well"
cat > /etc/X11/xorg.conf.d/30-pointer.conf <<FILE
Section "InputClass"
    Identifier "pointer"
    Driver "libinput"
    MatchIsPointer "on"
    Option "NaturalScrolling" "true"
EndSection
FILE

# cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<FILE
# Section "InputClass"
#   Identifier "system-keyboard"
#   MatchIsKeyboard "on"
#   Option "XkbLayout"  "gb,us"
#   Option "XkbVariant" "nodeadkeys"
#   Option "XkbOptions" "apple:badmap"
# EndSection
# FILE

# cat > /etc/X11/xorg.conf.d/10-nvidia-brightness.conf <<FILE
# Section "Device"
#     Identifier     "Device0"
#     Driver         "nvidia"
#     VendorName     "NVIDIA Corporation"
#     BoardName      "[GeForce GT 750M Mac Edition]"
#     Option         "RegistryDwords" "EnableBrightnessControl=1"
# EndSection
# FILE


echo "Switch audio output from HDMI to PCH and Enable sound chipset powersaving"
# cat > /etc/udev/rules.d/90-xhc_sleep.rules <<FILE
cat > /etc/modprobe.d/alsa-base.conf <<FILE
options snd_hda_intel index=1,0 power_save=1
FILE

echo "Download and install brightness script"
curl https://gist.githubusercontent.com/ktec/155d4599a79dea985d3bdefde6f87903/raw/7f7ccd0ac2f8b3ad5731b624bdeaa931a49d8cfb/brightness -o /usr/local/bin/brightness
chmod +x /usr/local/bin/brightness

echo "Add rule to enable changing screen brightness without sudo"
cat > /etc/udev/rules.d/90-backlight.rules <<FILE
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video %S%p/brightness", \
  RUN+="/bin/chmod g+w %S%p/brightness", \
  RUN+="/bin/setpci -v -H1 -s 00:01.00 BRIDGE_CONTROL=0"
# disable wake from S3 on XHC1
# SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
FILE

echo "Download and install kbdlight script"
curl https://gist.githubusercontent.com/ktec/6efc41613a772f1e2807a14782478342/raw/21a1874b69e69b68b852306898aa826c41a01305/kbdlight -o /usr/local/bin/kbdlight
chmod +x /usr/local/bin/kbdlight

echo "Add rule to enable changing screen brightness without sudo"
cat > /etc/udev/rules.d/90-kbdlight.rules <<FILE
SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
  RUN+="/bin/chgrp video %S%p/brightness", \
  RUN+="/bin/chmod g+w %S%p/brightness"
FILE

read -p "Would you like to install bluetooth?" -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Install bluez"
    pacman -S --noconfirm bluez bluez-utils

# This is the "old" way
echo "Add rule to load bluetooth at boot"
cat > /etc/udev/rules.d/10-local.rules <<-FILE
# Set bluetooth power up
ACTION=="add", KERNEL=="hci0", RUN+="/usr/bin/hciconfig %k up"
FILE

    # This is the "new" way
    sed -i '/#AutoEnable=false/s/AutoEnable=true//' /etc/bluetooth/main.conf

    # TODO: Confirm the new way actually works - didn't seem to on first attempt
fi


regex='^[0-9a-zA-Z._-]+$'

while true; do
    read -p "Please enter a username " USERNAME
    if [[ $USERNAME =~ $regex ]]; then
      break
    else
      echo "Invalid name."
      echo "Username can only contain A-z0-9.-_"
      echo "Please try again."
    fi
done

echo "Hello ${USERNAME}"
echo "We're now going to set up a user account for you."

useradd -m -g users -G wheel -s /bin/bash $USERNAME
passwd $USERNAME

echo "Add user to video group"
gpasswd -a $USERNAME video

echo "Add user to bluetooth group"
gpasswd -a $USERNAME lp

echo "Enable wheel users for sudo commands"
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

echo "Download setup user setup"
curl https://raw.githubusercontent.com/ktec/arch/master/user.sh -o /setup/user.sh
chmod +x /setup/user.sh

echo "Now run the user setup"
sudo -u $USERNAME /setup/user.sh
