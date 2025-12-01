# fdisk -l to see drives
# fdisk to configure: n (new volume) +XG for size in gibs t (change partition type) g (new efi table)
# configuration: 1gib boot 48gib swap rest filesystem
# /dev/nvmeboot
# /dev/nvmeswap
# /dev/nvmeroot

# FILESYSTEM CONFIG
mkfs.fat -F 32 /dev/nvmeboot
mkfs.btrfs /dev/nvmeroot
mkswap /dev/nvmeswap
mount /dev/root /mnt
# Create the subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
# Compress the subvolumes
mount -o compress=zstd,subvol=@ /dev/nvmeroot /mnt
mount --mkdir -o compress=zstd,subvol=@home /dev/nvmeroot /mnt/home

# MOUNT SWAP AND BOOT
swapon /dev/nvmeswap
mount --mkdir /dev/nvmeboot /mnt/boot

# MAIN INSTALLATION
pacstrap -K /mnt base base-devel linux linux-firmware amd-ucode efivar git go iwd fastfetch btrfs-progs timeshift vim networkmanager dhcpcd reflector zsh zsh-completions zsh-autosuggestions openssh man sudo tree 7zip

# AUTOMOUNT
# Fetch the disk mounting points as they are now ( we mounted everything before ) and generate instructions to let the system know how to mount the various disks automatically
genfstab -U /mnt >> /mnt/etc/fstab
# IMPORTANT: CHECK THE FSTAB AND CHANGE EFI FMASK AND DMASK TO 0077

# SYSTEM PRIMARY CONFIGURATION
arch-chroot /mnt # enter the fresh boot
# set time
ln -sf /usr/share/zoneinfo/Area/Location /etc/localtime # Area/Location eg: America/Chicago
hwclock --systohc
# set localization
localectl set-locale LANG=code.charset # e.g. LANG=en_US.UTF-8
# set hostname
vim /etc/hostname
# set password
passwd # (sec q: wisteri.art)
# BOOTLOADER
efivar --list ## ensure efi variables accesible
bootctl install
vim boot/loader/loader.conf
# default   arch.conf
# timeout  4
# console-mode  max
# editor  no
lsblk -dno UUID /dev/nvmeroot #e.g. f161a87d-6393-4d94-860f-9fe64aea175e
vim boot/loader/entries/arch.conf
# title  Arch Linux
# linux  /vmlinuz-linux
# initrd  /initramfs-linux.img
# options  root=UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX rw
# MAKE SURE THAT EVERYTHING IS IN THE EFI PARTITION
systemctl enable systemd-boot-update.service # update systemd

# REBOOT
exit
umount -R /mnt # check for busy partitions
reboot

#internet
systemctl enable iwd.service systemd-resolved.service systemd-networkd.service NetworkManager.service

# yay
cd bin && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# neovim
yay -S neovim-git

# desktop environment
sudo pacman -S plasma-desktop plasma-nm kscreen spectacle clipboard dolphin plasma-pa pipewire-pulse qt6-tools # chose pipeline and ffmpeg
yay -S ksysguard6-git
yay -s ksysguard-gpu
sudo nvim /etc/pacman.conf
# find [multilib] and uncomment to:
# [multilib]
# Include = /etc/pacman.d/mirrorlist
sudo pacman -Syu

# important apps
sudo pacman -S alacritty # tty emulator
sudo pacman -S nodejs # dep for ffox
yay -S firefox-nightly parsec
sudo pacman -S darktable
sudo pacman -S krita
