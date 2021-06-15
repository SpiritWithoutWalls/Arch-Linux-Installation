#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_TW.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub efibootmgr mtools dosfstools base-devel linux-headers os-prober \
 		  networkmanager network-manager-applet wpa_supplicant bluez bluez-utils terminus-font \
 		  iptables-nft ipset firewalld \
 		  pipewire pipewire-alsa pipewire-pulse pipewire-jack alsa-utils \
 		  dialog git reflector xdg-user-dirs xdg-utils rsync tlp

# If Arch is installed in VMware
pacman -S  open-vm-tools xf86-input-vmmouse xf86-video-vmware mesa
# pacman -S --noconfirm xf86-video-amdgpu

# pacman -S avahi nss-mdns cups gvfs gvfs-smb nfs-utils ntfs-3g bash-completion 
# pacman -S acpi acpi_call acpid
# pacman -S bridge-utils dnsmasq dnsutils inetutils openssh openbsd-netcat
# pacman -S virt-manager qemu qemu-arch-extra edk2-ovmf vde2
# pacman -S flatpak
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
# systemctl enable cups.service
# systemctl enable sshd
# systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
# systemctl enable libvirtd
systemctl enable firewalld
# systemctl enable acpid

useradd -m testuser
echo testuser:password | chpasswd
# usermod -aG libvirt erebus

echo "testuser ALL=(ALL) ALL" >> /etc/sudoers.d/testuser

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
