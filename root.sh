#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# ------------------------------------------------------
# All code here is run as root
# ------------------------------------------------------

echo "Install terminus font"
pacman -S --noconfirm terminus-font # A font we can read
setfont ter-v32n
echo 'FONT=ter-v32n' >> /etc/vconsole.conf

echo "Enable networking using Network Manager"
systemctl disable dhcpcd
pacman -S networkmanager network-manager-applet networkmanager-openvpn
systemctl disable dhcpcd.service
systemctl enable NetworkManager.service

read -p "Would you like to connect to wifi [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  nmcli dev wifi rescan
  WIFIS=$(nmcli -t dev wifi list|cut -d':' -f2)

  echo "Which wifi would you like to connect to?"
  select WIFI in $WIFIS exit; do
    case $WIFI in
      exit) echo "exiting"
            exit 0 ;;
         *) nmcli dev wifi connect $WIFI;
            break ;;
    esac
  done
fi

echo "Lets update Arch and install the linux headers"
pacman -Syu
pacman -S linux{,-headers}

echo "Setup locale"
echo 'LANG="en_GB.UTF-8"' >> /etc/locale.conf
echo 'LC_COLLATE="C"' >> /etc/locale.conf
sed -i '/#en_GB/s/^#//' /etc/locale.gen
export LC_ALL='en_GB.UTF-8'
locale-gen
rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

echo "Configure keyboard"
# localectl set-keymap de-latin1-nodeadkeys
# localectl set-x11-keymap de-latin1-nodeadkeys
# https://wiki.archlinux.org/index.php/Apple_Keyboard
# tee /sys/module/hid_apple/parameters/iso_layout <<< 0
# This doesn't seem to work in our favour - fn keys stop working with it
# echo "options hid_apple fnmode=0" | tee /etc/modprobe.d/hid_apple.conf
# echo 'FILES="$FILES:/etc/modprobe.d/hid_apple.conf"' | tee -a /etc/mkinitcpio.conf

# cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<FILE
# Section "InputClass"
#   Identifier "system-keyboard"
#   MatchIsKeyboard "on"
#   Option "XkbLayout"  "gb,us"
#   Option "XkbVariant" "nodeadkeys"
#   Option "XkbOptions" "apple:badmap"
# EndSection
# FILE


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
BOOTUUID=$(blkid | grep sda2 | sed 's/.*PARTUUID="\(.*\)".*/PARTUUID=\1/g')
SWAPUUID=$(blkid | grep sda3 | sed 's/.*UUID="\(.*\)".*/UUID=\1/g')
cat > /boot/loader/entries/arch.conf <<FILE
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=$BOOTUUID resume=$SWAPUUID rw quiet splash acpi_mash_gpe=0x17
FILE

# TODO: Automate this!
echo """
# edit /etc/mkinitcpio.conf
# HOOKS=\"base udev resume autodetect modconf block filesystems keyboard fsck\"
#                    ^^^
"""

echo "Update intramfs"
mkinitcpio -p linux

echo "Ensure the bootloader is updated after updating systemd"
cat > /etc/pacman.d/hooks/systemd-boot.hook <<FILE
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
FILE

echo "Install some stuff"
pacman -S --noconfirm dialog git sudo htop wget gvim acpi
# pacman -S --noconfirm nvidia
pacman -S --noconfirm xorg-server xorg-apps xorg-xinit xorg-twm xterm
pacman -S --noconfirm i3-gaps dmenu i3lock i3status
pacman -S --noconfirm rxvt-unicode gtk2-perl
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
pacman -S --noconfirm redshift
pacman -S --noconfirm xfce4-power-manager

echo "Enable system services"
systemctl enable acpid
systemctl enable ntpd
systemctl enable avahi-daemon
systemctl enable org.cups.cupsd.service

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
    Option "AccelSpeed" "0.4"
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


read -p "Would you like to hibernate on low battery?" -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
echo "Add rule to hibernate on low battery level"
cat > /etc/udev/rules.d/99-low-battery-hibernate.rules <<FILE
# Suspend the system when the battery level drops to 5% or lower
SUBSYSTEM=="power_supply", \
  ATTR{status}=="Discharging", \
  ATTR{capacity}=="[0-5]", \
  RUN+="/usr/bin/systemctl hibernate"
FILE
fi

# read -p "Would you like to install bluetooth?" -n 1
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     echo "Install bluez"
#     pacman -S --noconfirm bluez bluez-utils

# # This is the "old" way
# echo "Add rule to load bluetooth at boot"
# cat > /etc/udev/rules.d/10-local.rules <<-FILE
# # Set bluetooth power up
# ACTION=="add", KERNEL=="hci0", RUN+="/usr/bin/hciconfig %k up"
# FILE

#     # This is the "new" way
#     sed -i '/#AutoEnable=false/s/AutoEnable=true//' /etc/bluetooth/main.conf

#     # TODO: Confirm the new way actually works - didn't seem to on first attempt
# fi

read -p "Would you like to setup a low battery alarm? [y/N]? " -n 1echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
cat > /etc/acpi/events/low_battery_warning <<FILE
event=battery.*
action=/etc/acpi/actions/low_battery_warning.sh %e
FILE
fi


read -p "Would you like to setup bluetooth [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    pacman -S --noconfirm bluez bluez-utils
    systemctl enable bluetooth.service
    systemctl start bluetooth.service
    systemctl status bluetooth.service
    echo "Try: agent on\npower on\nscan on\n"
    echo "Also change autoenable: /etc/bluetooth/main.conf"
    echo "Use bluetoothctl"
fi

read -p "Would you like to prevent suspend when docked? [y/N]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sed -i '/#HandleLidSwitchDocked/s/^#//' /etc/systemd/logind.conf
    systemctl restart systemd-logind.service
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
