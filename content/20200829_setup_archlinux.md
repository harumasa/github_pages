---
title: "How to setup Arch Linux (Hyper, Visual Studio Code, Docker)"
date: 2020-08-29T00:00:00+09:00
lastmod: 2022-08-10T00:00:00+09:00
draft: false
---

## Introduction

- Model: DELL Inspiron 14 (5485)
- OS: Arch Linux
- Hyper
- Visual Studio Code
- Docker

## Installation guide

- [Installation guide](https://wiki.archlinux.org/title/Installation_guide "Installation guide")

- [archinstall](https://wiki.archlinux.org/title/Archinstall "archinstall")

[archinstall](https://wiki.archlinux.org/title/Archinstall "archinstall") is a helper library to install Arch Linux. It is packaged with different pre-configured installers, such as a "guided" installer.
[Installation guide](https://wiki.archlinux.org/title/Installation_guide "Installation guide") 1.8. through 5. are automated.

### 1. Pre-installation

#### 1.1 Acquire an installation image

- [Arch Linux Downloads](https://www.archlinux.org/download/ "Arch Linux Downloads")

#### 1.2. Verify signature

```zsh
gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
```

#### 1.3. Prepare an installation medium

```zsh
dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress
```

#### 1.4. Boot the live environment

Set BIOS configuration: Press F2

- Sleep Mode: Force S3
- Fast Boot: Thorough (Disabled)
- Secure Boot: Disabled

Boot from the USB flash drive: Press F12

#### 1.5. Set the console keyboard layout

```zsh
loadkeys jp106
```

#### 1.6. Verify the boot mode

```zsh
ls /sys/firmware/efi/efivars
```

#### 1.7. Connect to the Internet

```zsh
iwctl

[iwd]# device list
[iwd]# station ${DEVICENAME} scan
[iwd]# station ${DEVICENAME} get-networks
[iwd]# station ${DEVICENAME} connect ${SSID}
[iwd]# quit
```

```zsh
ping archlinux.org
```

#### 1.8. Update the system clock

```zsh
timedatectl set-ntp true
timedatectl status
```

#### 1.9. Partition the disks

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
2. 100% size partiton # Hex code 8300
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

#### 1.10. Format the partitions

```zsh
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/mapper/vg0-root
```

#### 1.11. Mount the file systems

```zsh
mount /dev/mapper/vg0-root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
lsblk /dev/nvme0n1
```

### 2. Installation

#### 2.1. Select the mirrors

- [Pacman Mirrorlist Generator](https://www.archlinux.org/mirrorlist/ "Pacman Mirrorlist Generator")

```zsh
nano /etc/pacman.d/mirrorlist
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
127.0.1.1 ${MYHOSTNAME}
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
mkinitcpio -p
```

#### 3.7. Root password

```zsh
passwd
```

#### 3.8. Boot loader

Install systemd-boot

```zsh
bootctl install
```

Setup systemd-boot

```zsh
nano /boot/loader/loader.conf

default arch.conf
timeout 4
console-mode max
editor  no
```

Adding loaders

```zsh
nano /boot/loader/entries/arch.conf

title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
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

- [General recommendations](https://wiki.archlinux.org/title/general_recommendations "General recommendations")

### 1. System administration

#### 1.1. Users and groups

Login with root account

```zsh
useradd -m -g users -G wheel ${USERNAME}
passwd ${USERNAME}
```

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

Utilizing multiple cores on compression

```zsh
sudo nano /etc/makepkg.conf

Change line COMPRESSXZ=(xz -c -z - --threads=0)
```

#### 2.5. Arch User Repository

Setup paru (AUR Helper)

```zsh
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd
rm -rf paru
```

Update all packages

```zsh
paru
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

### 5. Power management

#### 5.1. ACPI events

- xfce4-power-manager
  - System
    - On battery
      - System power saving
        - System sleep mode: Suspend
      - Laptop Lid
        - when laptop lid is closed: Suspend
    - Plugged in
      - System power saving
        - System sleep mode: Suspend
      - Laptop Lid
        - when laptop lid is closed: Suspend

To disable both blanking and DPMS, right click on the power manager system tray icon or left click on the panel applet and make sure that the option labelled Presentation mode is ticked.

### 6. Multimedia

#### 6.1. Sound System

```zsh
sudo pacman -S pipewire
```

### 7. Networking

#### 7.3. Setting up a firewall

- [Uncomplicated Firewall](https://wiki.archlinux.jp/index.php/Uncomplicated_Firewall "Uncomplicated Firewall")

```zsh
sudo pacman -S ufw gufw
sudo systemctl enable ufw
sudo systemctl status ufw
sudo ufw enable
sudo ufw status
```

### 8. Input Devices

#### 8.1. Keyboard layouts

- xfce4-settings
  - Keyboard
    - behavior
      - Typing Settings > Repeat speed: 100

#### 8.2. Mouse buttons

Install IMWheel

```zsh
paru -S imwheel
```

Setup IMWheel

```zsh
nano ~/.imwheelrc

".*"
None, Up, Button4, 3
None, Down, Button5, 2
```

Run IMWheel

```zsh
imwheel
```

Run IMWheel on startup using a service

- xfce4-session
  - Application Autostart
    - Add application
      - Name: imwheel
      - Command: /usr/bin/imwheel
      - Trigger: on login

#### 8.3. Laptop touchpads

```zsh
sudo pacman -S xf86-input-libinput
```

- xfce4-settings
  - Mouse and Touchpad
    - Devices
      - Devices: DELL Touchpad
        - Buttons and Feedback
          - Buttons: Reverse scroll direction: on
        - Touchpad
          - General: Tap touchpad to click: on

### 11. Appearance

#### 11.1. Fonts

- [Google Fonts](https://fonts.google.com "Google Fonts")

```zsh
sudo pacman -S noto-fonts{,-cjk,-emoji,-extra}
```

- xfce4-settings
  - Appearance
    - Fonts
      - Default Font: Noto Sans CJK JP Regular, 18pt
      - Default Monospace Font: Noto Sans Mono CJK JP Regular, 18pt

- [Ricty Diminished](https://github.com/edihbrandon/RictyDiminished "Ricty Diminished")

```zsh
sudo mkdir -p /usr/share/fonts/TTF
git clone https://github.com/edihbrandon/RictyDiminished.git
cd RictyDiminished
sudo cp *.ttf /usr/share/fonts/TTF
fc-cache -vf
cd
rm -rf RictyDiminished
```

### 12. Console improvements

#### 12.3. Alternative shells

Setup Zsh

```zsh
sudo pacman -S zsh
zsh
chsh -s $(which zsh)
```

Setup Prezto

```zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

```zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

```zsh
nano ~/.zpreztorc

+++
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'history-substring-search' \
  'autosuggestions' \ # Add
  'git' \ # Add
  'syntax-highlighting' \ # Add
  'prompt'
+++
# Auto set to 'off' on dumb terminals.
zstyle ':prezto:module:prompt' theme 'pure' # sorin to pure
+++
```

```zsh
source ~/.zpreztorc
```

#### 12.5. Colored output

```zsh
sudo nano /etc/pacman.conf

Uncommment line Color
```

## Localization/Japanese

- [Localization/Japanese](https://wiki.archlinux.org/title/Localization/Japanese "Localization/Japanese")

### 3. Input methods

#### 3.3. Mozc

Setup Mozc and Fcitx

```zsh
sudo pacman -S fcitx5-im fcitx5-mozc
```

Set environment variables for IM modules

```zsh
sudo nano /etc/environment

GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS=@im=fcitx5
```

Reboot

```zsh
reboot
```

- Fcitx 5 Configuration
  - Input Method
    - Add Mozc

## Hyper

- [Hyper](https://hyper.is "Hyper")

```zsh
paru -S hyper
```

### 1. Preferences

```zsh
+++
module.exports = {
  config: {
    +++
    // default font size in pixels for all tabs
    fontSize: 18, # Change

    // font family with optional fallbacks
    fontFamily: 'Ricty Diminished', # Change
    +++
    +++
    // rest of the config # Add
    opacity: 0.80, # Add
  },
  +++
  +++
  plugins: [
    "hyper-material-theme", # Add
    "hyper-opacity", # Add (Only works on Windows and macOS)
  ],
  +++
};
```

## Visual Studio Code

- [Visual Studio Code](https://azure.microsoft.com/en-us/products/visual-studio-code/ "Visual Studio Code")

```zsh
paru -S visual-studio-code-bin
sudo pacman -S gnomekeyring
```

### 1. Accounts

- Setting Sync is On

Installed Extensions

- Docker
- GitHub Theme
- GlassIt-VSC
- Jupyter
- Jupyter Keymap
- Jupyter Notebook Renderers
- markdownlint
- Marp for VS Code
- Material Icon Theme
- Path Intellisense
- Prettier - Code formatter
- Pylance
- Python
- Remote - Containers
- Remote - SSH
- Remote - WSL
- Remote Development
- Trailing Spaces
- YAML

## Docker

- [Docker](https://www.docker.com "Docker")

```zsh
sudo pacman -S docker
sudo systemctl enable docker
sudo pacman -S docker-compose
```

## ETC

```zsh
sudo pacman -S firefox
sudo pacman -S firefox-i18n-ja
paru -S google-chrome
```
