#!/bin/bash
# Copyright (c) 2018 Keith Salisbury

# To run this download the file and execute
# You "could" try this:
# bash <(curl -Ls https://raw.githubusercontent.com/ktec/arch/master/start.sh)

# Use a more readable font
# setfont sun12x22

read -r -p "Would you repartition your drives [y/N]? "

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Configure disks with GPT"
  (
  echo o              # Clear all partitions
  echo y              # Confirm

  echo n              # Add a new partition
  echo                # Partition number (Accept default)
  echo                # First sector (Accept default)
  echo +550M          # Last sector
  echo ef00           # EFI Partition type

  echo n              # Add a new partition
  echo                # Partition number (Accept default)
  echo                # First sector (Accept default)
  echo +32G           # Parition Size
  echo 8304           # Linux root partition type

  echo n              # Add a new partition
  echo                # Partition number (Accept default)
  echo                # First sector (Accept default)
  echo +16G           # Parition Size
  echo 8200           # Linux swap type

  echo n              # Add a new partition
  echo                # Partition number (Accept default)
  echo                # First sector (Accept default)
  echo +128G           # Parition Size
  echo 8304           # Linux root partition type

  echo n              # Add a new partition
  echo                # Partition number (Accept default)
  echo                # First sector (Accept default)
  echo                # Last sector (Accept default)
  echo 8302           # Linux swap type

  echo w              # Write changes
  echo yes            # Confirm
  ) | gdisk /dev/sda

  echo "Create filesystems"
  mkfs.vfat -F32 /dev/sda1
  echo "y" | mkfs.ext4 /dev/sda2
  echo "y" | mkfs.ext4 /dev/sda4
  echo "y" | mkfs.ext4 /dev/sda5
  mount /dev/sda2 /mnt
  mkdir -p /mnt/boot && mount /dev/sda1 /mnt/boot
  mkdir -p /mnt/var && mount /dev/sda4 /mnt/var
  mkdir -p /mnt/home && mount /dev/sda5 /mnt/home
  mkswap /dev/sda3 && swapon /dev/sda3
fi

read -r -p "Would you like to edit the mirror list [y/N]? "

if [[ $input =~ ^[Yy]$ ]]; then
  vim /etc/pacman.d/mirrorlist
fi

echo "update pgp keys"
dirmngr </dev/null
pacman-key --populate archlinux
pacman-key --refresh-keys

echo "Install base"
pacstrap /mnt base base-devel linux linux-firmware

echo "Save file system table"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "Download setup part 2"
curl -O https://raw.githubusercontent.com/ktec/arch/master/root.sh
mkdir -p /mnt/setup
chmod +x root.sh && mv root.sh /mnt/setup

echo "Now configure CHROOT"
arch-chroot /mnt /setup/root.sh

# umount -R /mnt

echo "Installation complete. Please reboot and log in."
# systemctl reboot
