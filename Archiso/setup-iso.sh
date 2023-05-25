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
read -p "Do you want to update your system? (yes/no) " answer

if [ "$choice" == "yes" ]; then
    echo "Updating the system..."
    sudo pacman -Syu
    echo "System updated successfully."
else
    echo "Exiting without updating the system."
fi

# Sync, update, and prepare system
echo '[3/6] Syncing repositories and updating system packages'
sudo pacman-mirrors --fasttrack && sudo pacman -Syyu --noconfirm 
sudo pacman -Syyu --noconfirm --needed git git-lfs multilib-devel devtools libisoburn squashfs-tools make archiso qemu-desktop openssh

# Install android build prerequisites
echo '[4/6] Installing Android building prerequisites'
packages="ncurses5-compat-libs lib32-ncurses5-compat-libs aosp-devel xml2 lineageos-devel"
for package in $packages; do
    echo "Installing $package"
    git clone https://aur.archlinux.org/"$package"
    cd "$package" || exit
    makepkg -si --skippgpcheck --noconfirm --needed
    cd - || exit
    rm -rf "$package"
done

# Install adb and associated udev rules
echo '[5/6] Installing adb convenience tools'
sudo pacman -S --noconfirm --needed android-tools android-udev

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

# Install from yay
#yay -S --noconfirm android-sdk



# Black arch
echo '[6/6] Black arch setup'
read -p "Do you want to proceed with the BlackArch setup? (yes/no) " answer

if [ "$answer" == "yes" ]; then
    echo "Downloading strap.sh..."
    curl -O https://blackarch.org/strap.sh

    echo "Verifying strap.sh checksum..."
    echo "5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh" | sha1sum -c -

    echo "Setting execute permission for strap.sh..."
    chmod +x strap.sh

    echo "Running strap.sh with sudo..."
    sudo ./strap.sh

    echo "Updating system packages..."
    sudo pacman -Syyu
  
    echo "BlackArch setup completed successfully."
else
    echo "BlackArch setup skipped."
fi

# Complete
echo 'Setup completed, enjoy'
