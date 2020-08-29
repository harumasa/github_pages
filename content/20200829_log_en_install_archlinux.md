---
title: "Install Arch Linux with encrypted file-system and UEFI on DELL Inspiron 14 (5485)"
date: 2020-08-29T00:00:00+09:00
lastmod: 2020-08-29T00:00:00+09:00
draft: false
---

## Installation guide

[The official installation guide](https://wiki.archlinux.org/index.php/Installation_guide/)

### 1. Pre-installation

[Arch Linux Downloads](https://www.archlinux.org/download/)

#### 1.1. Verify signature

#### 1.2. Boot the live environment

Copy to a USB flash drive on GNU/linux

```zsh
dd bs=4M if=path/to/archlinux.iso of=/dev/sdX status=progress oflag=sync
```

Set BIOS configuration: Press F2

- Fast Boot: Thorough (Disabled)
- Secure Boot: Disabled

Boot from the USB flash drive: Press F12

#### 1.3. Set the keyboard layout

```zsh
loadkeys jp106
```

#### 1.4. Verify the boot mode

```zsh
ls /sys/firmware/efi/efivars
```

#### 1.5. Connect to the Internet

```zsh
iwctl
```

```zsh
[iwd]# device list
[iwd]# station ${DEVICENAME} scan
[iwd]# station ${DEVICENAME} get-networks
[iwd]# station ${DEVICENAME} connect SSID
```

```zsh
ping archlinux.org
```

#### 1.6. Update the system clock

```zsh
timedatectl set-ntp true
timedatectl status
```

#### 1.7. Partition the disks

Identify devices

```zsh
fdisk -l
```

Example layout (UEFI with GPT)

|Mount point:|Partition:|Partition type:|Size:|
|----|----|----|----|
|/mnt/boot|/dev/nvme0n1p1|EFI system partition|512 MB|
|/mnt|/dev/nvme0n1p2|Linux filesystem|Remainder of the device|

Create partitions

```zsh
cgdisk /dev/nvme0n1

1. 512MB EFI partition # Hex code ef00
2. 100% size partiton # Hex code 8300 (to be encrypted)
```

Encrypting devices

```zsh
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open --type luks /dev/nvme0n1p2 cryptroot
```

Create encrypted partitions

```zsh
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -l +100%FREE vg0 -n root
```

#### 1.8. Format the partitions

```zsh
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/mapper/vg0-root
```

#### 1.9. Mount the file systems

```zsh
mount /dev/mapper/vg0-root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
lsblk /dev/nvme0n1
```

### 2. Installation

#### 2.1. Select the mirrors

```zsh
nano /etc/pacman.d/mirrorlist

Move the geographically closest mirrors to the top of the list
```

[Pacman Mirrorlist Generator](https://www.archlinux.org/mirrorlist/)

```zsh
## Japan
Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
Server = https://mirrors.cat.net/archlinux/$repo/os/$arch
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = https://jpn.mirror.pkgbuild.com/$repo/os/$arch
```

#### 2.2. Install essential packages

```zsh
pacstrap /mnt base base-devel linux linux-firmware nano
```

### 3. Configure the system

#### 3.1. Fstab

```zsh
genfstab -U /mnt >> /mnt/etc/fstab
```

#### 3.2. Chroot

```zsh
arch-chroot /mnt
```

#### 3.3. Time zone

```zsh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc
```

#### 3.4 Localization

Uncomment locales

```zsh
nano /etc/locale.gen

Uncomment line en_US.UTF-8 UTF-8
Uncomment line ja_JP.UTF-8 UTF-8
```

Generate locales

```zsh
locale-gen
```

Set the language and keyboard layout

```zsh
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=jp106 > /etc/vconsole.conf
```

#### 3.5. Network configuration

Set the hostname

```zsh
echo ${MYHOSTNAME} > /etc/hostname
```

Add matching entries

```zsh
nano /etc/hosts

127.0.0.1 localhost
::1       localhost
127.0.1.1 ${MYHOSTNAME}.localdomain ${MYHOSTNAME}
```

Setup NetworkManager

```zsh
pacman -S networkmanager dhcpcd
systemctl enable NetworkManager
```

#### 3.6. Initramfs

Modify mkinitcpio.conf

```zsh
nano /etc/mkinitcpio.conf

Add 'ext4' to MODULES
Add 'encrypt' and 'lvm2' to HOOKS before 'filesystems'
```

Recreate the initramfs image

```zsh
pacman -S lvm2
mkinitcpio -p linux
```

#### 3.7. Root password

```zsh
passwd
```

#### 3.8. Boot loader

Install systemd-boot

```zsh
bootctl --path=/boot install
```

If the bootctl install command failed, you can create a EFI boot entry manually using efibootmgr

The path to the EFI image must use the backslash ( \ ) as the separator

```zsh
pacman -S efibootmgr
efibootmgr -c -d /dev/sda1 -p 1 -l "\EFI\systemd\systemd-bootx64.efi" -L "Linux Boot Manager"
```

Setup systemd-boot

```zsh
nano /boot/loader/loader.conf

default arch
timeout 3
editor  no
```

Check UUID

```zsh
blkid -s UUID -o value /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf
```

Adding loaders

```zsh
nano /boot/loader/entries/arch.conf

title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=${UUID}:vg0 root=/dev/mapper/vg0-root rw
```

Setup Microcode

```zsh
pacman -S amd-ucode
```

#### 4. Reboot

```zsh
exit
umount -R /mnt
reboot
```

#### 5. Post-installation

Login with root account

Setup NetworkManager

```zsh
nmtui
```

## General recommendations

### 1. System administration

#### 1.1. Users and groups

Login with root account

```zsh
useradd -m -g users -G wheel ${USERNAME}
passwd ${USERNAME}
```

#### 1.2. Privilege elevation

To allow members of group wheel sudo access

```zsh
EDITOR=nano visudo

Uncommment line %wheel ALL=(ALL) ALL
Uncommment line %wheel ALL=(ALL) NOPASSWD: ALL
```

Return to regular user

```zsh
exit
```

### 2. Package management

#### 2.1. pacman

Update all packages

```zsh
sudo pacman -Syu
```

#### 2.5. Arch User Repository

Setup yay (AUR Helper)

```zsh
sudo pacman -S git
mkdir -p ~/src/github.com
cd src/github.com
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
sudo pacman -Rs go
```

Utilizing multiple cores on compression

```zsh
sudo nano /etc/makepkg.conf

Change line COMPRESSXZ=(xz -c -z - --threads=0)
```

Update all packages

```zsh
yay
```

### 4. Graphical user interface

#### 4.1. Display server

```zsh
sudo pacman -S xorg-server xorg-apps
sudo localectl set-x11-keymap jp
```

#### 4.2. Display drivers

```zsh
lspci | grep -e VGA -e 3D
sudo pacman -S xf86-video-amdgpu
```

#### 4.3. Desktop environments

Setup Xfce

```zsh
sudo pacman -S xfce4 xfce4-goodies
```

Set the language

```zsh
sudo nano /etc/locale.conf

LANG=ja_JP.UTF-8
```

Reboot

```zsh
reboot
```

#### 4.5. Display manager

```zsh
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service
```

### 6. Multimedia

#### 6.1. Sound

```zsh
sudo pacman -S pulseaudio pavucontrol
```

### 8. Input Devices

#### 8.3. Laptop touchpads

```zsh
sudo pacman -S xf86-input-libinput
```

### 11. Appearance

#### 11.1. Fonts

```zsh
sudo pacman -S noto-fonts-cjk
```

### 12. Console improvements

#### 12.3. Alternative shells

Setup Zsh

```zsh
sudo pacman -S zsh
chsh -s $(which zsh)
```

#### 12.5. Colored output

```zsh
sudo nano /etc/pacman.conf

Uncommment line Color
```

### 91. Localization/Japanese

#### 91.4 Input methods

Setup Fcitx and Mozc

```zsh
sudo pacman -S fcitx fcitx-mozc fcitx-im fcitx-configtool
```

Set environment variables for IM modules

```zsh
nano ~/.xprofile

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

```zsh
reboot
```

### 92. Settings

- Settings > Appearance > Fonts
  - Default Font Noto Sans CJK JP Regular, 9pt
  - Default Monospace Font Noto Sans Mono CJK JP Regular, 9pt

- Settings > FcitxConfiguration > Input Method
  - Add Mozc

### 99. etc

```zsh
yay -S prezto-git
yay -S hyper-git
yay -S visual-studio-code-bin
yay -S anaconda
sudo pacman -S docker
sudo systemctl enable docker
sudo pacman -S git
sudo pacman -S firefox
sudo pacman -S firefox-i18n-ja
yay -S google-chrome
```
