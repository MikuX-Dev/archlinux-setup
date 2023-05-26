#!/bin/bash

# Define the available options
options=("Arch-Manjaro" "ArchInstall" "Archiso" "AOSP-Setup")

# Prompt the user to select an option
echo "Please select an option:"
select option in "${options[@]}"; do
  case $option in
    "Arch-Manjaro")
      # Set the sh file path for Arch-Manjaro
      sh_file="aosp-setup/setup/arch-manjaro.sh"
      break
      ;;
    "ArchInstall")
      # Prompt the user to select an option within ArchInstall
      archinstall_options=("archfi.sh" "archinstall.sh" "vm.sh")
      echo "Please select an option within ArchInstall:"
      select archinstall_option in "${archinstall_options[@]}"; do
        case $archinstall_option in
          "archfi.sh")
            # Set the sh file path for archfi.sh
            sh_file="ArchInstall/archfi.sh"
            break
            ;;
          "archinstall.sh")
            # Set the sh file path for archinstall.sh
            sh_file="ArchInstall/archinstall.sh"
            break
            ;;
          "vm.sh")
            # Set the sh file path for vm.sh
            sh_file="ArchInstall/vm.sh"
            break
            ;;
          *)
            echo "Invalid option. Please try again."
            ;;
        esac
      done
      break
      ;;
    "Archiso")
      # Set the sh file path for setup-iso.sh
      sh_file="Archiso/setup-iso.sh"
      break
      ;;
    "AOSP-Setup")
      # Prompt the user to select an option within AOSP-Setup
      aosp_setup_options=("org.sh" "personal.sh")
      echo "Please select an option within AOSP-Setup:"
      select aosp_setup_option in "${aosp_setup_options[@]}"; do
        case $aosp_setup_option in
          "org.sh")
            # Set the sh file path for org.sh
            sh_file="aosp-setup/org.sh"
            break
            ;;
          "personal.sh")
            # Set the sh file path for personal.sh
            sh_file="aosp-setup/personal.sh"
            break
            ;;
          *)
            echo "Invalid option. Please try again."
            ;;
        esac
      done
      break
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done

# Execute the selected sh file if it exists and is executable
if [ -x "$sh_file" ]; then
  echo "Making $sh_file executable..."
  chmod +x "$sh_file"
  echo "Executing $sh_file..."
  ./"$sh_file"
else
  echo "Error: $sh_file is either missing or not executable."
fi
