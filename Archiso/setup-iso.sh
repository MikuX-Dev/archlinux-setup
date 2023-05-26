#!/usr/bin/env bash

# Script to setup an android build environment on Arch Linux and derivative distributions

clear
echo 'Starting Arch-based Android build setup'

# Uncomment the multilib repo, incase it was commented out
echo '[1/6] Enabling multilib repo'

# Check if multilib repository exists in pacman.conf
if grep -q "\[multilib\]" /etc/pacman.conf; then
    # Multilib repository exists, remove comment if it is commented out
  sudo sed -i '/^\[multilib\]/,/Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
else
    # Multilib repository does not exist, add it to pacman.conf
  echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
fi

# Update system
echo '[2/6] Update system'
read -p "Do you want to update your arch Linux mirror? (yes/no) " answer

if [ "$choice" == "yes" ]; then
    echo "Updating the system..."
    sudo chmod +x mirror.sh
    sudo ./mirror.sh
    echo "Updated archLinux mirror"
else
    echo "Exiting without updating the mirror."
fi

# Sync, update, and prepare system
echo '[3/6] Syncing repositories and updating system packages'
sudo pacman-mirrors --fasttrack && sudo pacman -Syyu --noconfirm 
sudo pacman -Syyu --noconfirm --needed git git-lfs multilib-devel devtools dosfstools mtools libisoburn libburn squashfs-tools make archiso qemu-desktop openssh

# Install android build prerequisites
echo '[4/6] Installing Android building prerequisites'
packages=""
for package in $packages; do
    echo "Installing $package"
    git clone https://aur.archlinux.org/"$package"
    cd "$package" || exit
    makepkg -si --skippgpcheck --noconfirm --needed
    cd - || exit
    rm -rf "$package"
done

# Check if yay is installed
if ! command -v yay &> /dev/null
then
    # Clone yay.git from GitHub
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Black arch

# Backup the existing pacman.conf file
sudo cp /etc/pacman.conf /etc/pacman.conf.backup

# Add BlackArch repository configuration to pacman.conf
sudo tee -a /etc/pacman.conf > /dev/null <<EOT

[blackarch]
Include = /etc/pacman.d/blackarch-mirrorlist
EOT

# Update package lists
sudo pacman -Sy

# Install archlinux-contrib package
sudo pacman -S archlinux-contrib

# Generate blackarch-mirrorlist file
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/blackarch-mirrorlist
sudo curl -o /etc/pacman.d/blackarch-mirrorlist https://archlinux.org/mirrorlist/all/
sudo sed -i 's/^#Server/Server/' /etc/pacman.d/blackarch-mirrorlist
sudo rankmirrors -v /etc/pacman.d/blackarch-mirrorlist > /etc/pacman.d/blackarch-mirrorlist.rank
sudo mv /etc/pacman.d/blackarch-mirrorlist.rank /etc/pacman.d/blackarch-mirrorlist

# Install blackarch-keyring package
sudo pacman -Syy blackarch-keyring

# Import BlackArch keyring
sudo blackarch-keyring --init

# Update package lists again
sudo pacman -Syyu

echo "BlackArch mirror has been added to Arch Linux."

# Complete
echo 'Setup completed, enjoy'
