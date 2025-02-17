#!/bin/bash

#* clear screen
clear

#! make this part interactive for sure :)
#* variables that should be edited
MACHINE_NAME='machinename'
ROOT_PASSWORD='password'
USER_NAME='username'
USER_PASSWORD='password'

#* setting time
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
hwclock --systohc

#* generating locales and setting up the host information
#? use sed to uncomment line instead of appending a new one
#sed '/en_US.UTF-8/s/^#//' -i /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "${MACHINE_NAME}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ${MACHINE_NAME}.localdomain ${MACHINE_NAME}" >> /etc/hosts
echo root:${ROOT_PASSWORD} | chpasswd

#* set up the pacman configuration
rm /etc/pacman.conf
wget --directory-prefix /etc/ https://raw.githubusercontent.com/Hibrit/archlinuxsettings/master/pacman/pacman.conf
pacman -Syy

#* installing essential packages
pacman -S --needed --noconfirm grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog mtools dosfstools base-devel linux-headers reflector openssh xdg-user-dirs tldr #os-prober ntfs-3g

#! install grub !!!THIS IS FOR UEFI USAGE ONLY!!!
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

#! if installing to a legacy system use this installation type instead
#! remember to change /dev/sdX path to drive
# grub-install --target=i386-pc /dev/sdX

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

#* adding user
useradd -mG wheel ${USER_NAME}
echo ${USER_NAME}:${USER_PASSWORD} | chpasswd

#* informing about suders file and going into edit mode
echo
echo 'please uncomment the relevant wheel line from sudoers file'
echo
sleep 3
EDITOR=vim visudo
mkdir /home/${USER_NAME}/Documents
cp -r /ais /home/${USER_NAME}/Documents/ais
chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/Documents
echo
echo 'please exit this tty session and proceed with scripts'
echo
