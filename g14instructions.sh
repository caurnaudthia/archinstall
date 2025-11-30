# ASSUMES STEPS IN asus-linux guide for pre-installation are completed
# G14 specific config
sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo nvim /etc/pacman.conf
# add the following at the bottom:
# [g14]
# Server = https://arch.asus-linux.org
sudo pacman -Syu # update repository
sudo pacman -S asusctl power-profiles-daemon rog-control-center
sudo systemctl enable --now power-profiles-daemon.service 
git clone https://gitlab.com/asus-linux/nvidia-laptop-power-cfg.git && cd nvidia-laptop-power-cfg && makepkg -sfi
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
sudo systemctl enable --now nvidia-powerd
# kernel update
sudo pacman -Sy linux-g14 linux-g14-headers
# IN ROOT ENVIRONMENT, set up a new entry for the bootloader
