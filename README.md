# Arch Linux for Macbook Pro 15" (Macbook Pro11,3)
Setup for using Arch linux + i3wm with macbookpro

IMPORTANT: This is work in progress, and as such is intended as reference material only for the time being.

## Machine Specs

MacBook Pro "Core i7" 2.6 15" Late 2013 (DG) 	2.6 GHz Core i7 (I7-4960HQ)

Intro. 	October 22, 2013 	Disc. 	July 29, 2014
Order 	ME874LL/A 	Model 	A1398 (EMC 2745)
Family 	Retina Late 2013 15" 	ID 	MacBookPro11,3
RAM 	16 GB* 	VRAM 	2 GB*
Storage 	512 GB SSD 	Optical 	None*

https://gist.github.com/ktec/73b874bbaf3d20fd7e9f75346a6888aa


# Getting Started

Create a bootable USB with Arch linux on it, reboot the machine and hold down "Alt" to bring up the boot menu. Now choose "EFI" to boot off the USB stick.Once you're in to a command prompt, now we need to get wifi working. Easiest way, is to plugin in a mobile, and use the USB tethering.

After that, follow these steps:

```
# ip link
...
# dhcpcd <your_interface_name>
...
# bash <(curl -Ls https://raw.githubusercontent.com/ktec/arch/master/setup.sh)
```

## Special Instructions

There is an ACPI interrupt which seems to go crazy - there are various solutions to prevent but the most successful (but equally vulgar) is to disable it during boot:

If you want to do this you can find out which interrupt are going crazy by running:
```
grep . -r /sys/firmware/acpi/interrupts/
```
If any has a crazy large number - that's the one. Mine is GPE17, so to disable it at boot, edit the boot script to look like this:

```
# /boot/loader/entries/arch.conf

title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=9ea22b9f-e6d6-4b81-a9b0-c3a4c5ea1f9a rw quiet acpi_mask
_gpe=0x17
```


## Notes on Printing for Canon

1. Install canon-pixma-mg5500-complete.
2. Ensure avahi service is started and operational.
3. Update `/etc/nsswitch.conf` and add `mdns4_minimal` to the line:
```
hosts:          files mdns4_minimal [NOTFOUND=return] dns mdns4
```
3. Ensure you can ping the printer, eg. `$ ping B72D71000000.local`

# Links

## Tutorials
  - https://medium.com/@laurynas.karvelis_95228/install-arch-linux-on-macbook-pro-11-2-retina-install-guide-for-year-2017-2034ceed4cb2
  - https://fusion809.github.io/how-to-install-arch-linux/
  - https://medium.com/@philpl/arch-linux-running-on-my-macbook-2ea525ebefe3
  - https://0xadada.pub/2016/03/05/install-encrypted-arch-linux-on-apple-macbook-pro/#configure-sound

## Video Tutorials
 - https://www.youtube.com/watch?v=pJefGOHHbD4
 - https://www.youtube.com/watch?v=DfC5hgdtbWY
 - https://www.youtube.com/watch?v=GKdPSGb9f5s
 - https://www.youtube.com/watch?v=lizdpoZj_vU
 - https://www.youtube.com/watch?v=L3yYEu-NKVI
 - https://www.youtube.com/watch?v=lgxiYMH5L_Y
 - https://www.youtube.com/watch?v=qmDtz0vVzCA
 - https://www.youtube.com/watch?v=_yMDTUgyJ4Y

## i3 Videos Tutorials
 - https://www.youtube.com/watch?v=8-S0cWnLBKg
 - https://www.youtube.com/watch?v=_kjbj-Ez1vU
 - https://www.youtube.com/watch?v=N_V7bKVuaRw


## i3 Customisations
 - https://terminal.sexy/
 - http://dotshare.it/dots/


# Install scripts
 - https://gist.github.com/SoreGums/9171333
 - https://github.com/helmuthdu/aui


## MacBookPro11

### Keyboard
 - https://keyshorts.com/blogs/blog/37615873-how-to-identify-macbook-keyboard-localization

### Backlight
 - https://wiki.archlinux.org/index.php/Mac#Keyboard_Backlight

### Wifi
 - https://github.com/antoineco/broadcom-wl
 - https://aur.archlinux.org/packages/broadcom-wl-lts
 - https://aur.archlinux.org/packages/broadcom-wl

### Graphics
 - https://wiki.archlinux.org/index.php/NVIDIA

## Useful Arch Wiki Links
  - https://wiki.archlinux.org/index.php/Microcode#systemd-boot
  - https://wiki.archlinux.org/index.php/MacBookPro11,x#Partitioning
  - https://wiki.archlinux.org/index.php/Apple_Keyboard#.3C_and_.3E_have_changed_place_with_.C2.A7_and_.C2.BD
  - https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg#Viewing_keyboard_settings
  - https://wiki.archlinux.org/index.php/Vim
  - https://wiki.archlinux.org/index.php/MacBookPro11,x#Setup_bootloader
  - https://wiki.archlinux.org/index.php/Arch_User_Repository#Searching
  - https://wiki.archlinux.org/index.php/EFI_System_Partition
  - https://wiki.archlinux.org/index.php/List_of_applications#Web_browsers
  - https://wiki.archlinux.org/index.php/Xinit
  - https://www.howtoforge.com/tutorial/install-arch-linux-server/

Get a network connections with mobile:
  - https://wiki.archlinux.org/index.php/Android_tethering

## i3wm docs
 - https://i3wm.org/docs/3.e/userguide.html#_exiting_i3

## Example dot files etc
  - https://github.com/laurynas-karvelis/dotfiles
  - https://github.com/laurynas-karvelis/dotfiles/blob/master/.config/i3/config
  - https://github.com/lleweldyn/i3-Laptop-MacbookPro
URxvt and other defaults:
  - https://raw.githubusercontent.com/LukeSmithxyz/voidrice/master/.Xdefaults
  - https://github.com/Grafikart/dotfiles
  - https://gist.github.com/jhaubrich/6558b9e1a97754b5a63c
  - https://github.com/pkkolos/urxvt-scripts

# i3 Rice
  - https://github.com/CSaratakij/i3-rice-rin-shelter


# Arch Distributions
 - https://archlabslinux.com/
