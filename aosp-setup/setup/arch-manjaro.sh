#!/usr/bin/env bash

# Script to setup an android build environment on Arch Linux and derivative distributions

clear
echo 'Starting Arch-based Android build setup'

# Uncomment the multilib repo, incase it was commented out
echo '[1/7] Enabling multilib repo'

# Check if multilib repository exists in pacman.conf
if grep -q "\[multilib\]" /etc/pacman.conf; then
    # Multilib repository exists, remove comment if it is commented out
  sudo sed -i '/^\[multilib\]/,/Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
else
    # Multilib repository does not exist, add it to pacman.conf
  echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
fi

# Sync, update, and prepare system
echo '[2/7] Syncing repositories and updating system packages'
sudo pacman-mirrors --fasttrack && sudo pacman -Syyu --noconfirm 
sudo pacman -Syyu --noconfirm --needed git git-lfs multilib-devel fontconfig ttf-droid code neovim gcc clang make rustc archiso qemu-desktop openssh devtools dosfstools mtools libisoburn libburn squashfs-tools

# Install android build prerequisites
echo '[3/7] Installing Android building prerequisites'
packages="ncurses5-compat-libs lib32-ncurses5-compat-libs aosp-devel xml2 lineageos-devel"
for package in $packages; do
    echo "Installing $package"
    git clone https://aur.archlinux.org/"$package"
    cd "$package" || exit
    makepkg -si --skippgpcheck --noconfirm --needed
    cd - || exit
    rm -rf "$package"
done

# Check if Java 17 is the default version
#if java -version 2>&1 | grep -q "version \"17"; then
#    echo "Java 17 is already the default version."
#else
    # Install Java 17
#    echo "Java 17 is not the default version. Installing..."
#    sudo pacman -S jdk17-openjdk --noconfirm
    
     # Set Java 17 as the default version
#    sudo archlinux-java set java-17-openjdk
#    echo "Java 17 installed and set as the default version successfully."
#fi

# Install adb and associated udev rules
echo '[4/7] Installing adb convenience tools'
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

# Path
#shell=$(basename $SHELL)
#path='/opt/android-sdk/tools:/opt/android-sdk/platform-tools:/opt/android-build:$PATH'

#if [ "$shell" = "bash" ]; then
#    if [ -f "$HOME/.bashrc" ]; then
#        echo "export PATH=\"$path\"" >> "$HOME/.bashrc"
#        echo "Added PATH to .bashrc"
#    else
#        echo "No .bashrc file found, PATH not added"
#        exit 1
#    fi
#elif [ "$shell" = "zsh" ]; then
#    if [ -f "$HOME/.zshrc" ]; then
#        echo "export PATH=\"$path\"" >> "$HOME/.zshrc"
#        echo "Added PATH to .zshrc"
#   else
#        echo "No .zshrc file found, PATH not added"
#        exit 1
#    fi
#else
#    echo "Unknown shell, PATH not added"
#    exit 1
#fi


# Config git 
echo '[5/7] Configuration of git'
read -p "Which git-config to use? (personal/org) " answer

if [ "$answer" == "personal" ]; then
    echo "Configuring personal git-config"
    sudo chmod +x ../personal-setup/personal.sh
    ../personal-setup/personal.sh
    echo "Personal git-configured successfully."
else
    echo "Configuring org git-config"
    sudo chmod +x ../personal-setup/org.sh
    ../personal-setup/org.sh
    echo "Org git-configured successfully."
fi

# Update system
echo '[6/7] Update system'
read -p "Do you want to update your system? (yes/no) " answer

if [ "$choice" == "yes" ]; then
    echo "Updating the system..."
    sudo pacman -Syu
    echo "System updated successfully."
else
    echo "Exiting without updating the system."
fi

# Black arch
echo '[7/7] Black arch setup'
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
    sudo pacman -Syu

    echo "Configuring BlackArch mirror..."
    #sudo sed -i 's/^Server/#Server/g' /etc/pacman.d/mirrorlist
    #sudo sed -i '/^#Server.*https/s/^#//' /etc/pacman.d/mirrorlist
    sudo pacman -Syyu
    
    echo "BlackArch setup completed successfully."
else
    echo "BlackArch setup skipped."
fi

# Complete
echo 'Setup completed, enjoy'
