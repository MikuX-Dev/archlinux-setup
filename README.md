# ArchInstall

Just a simple bash script wizard to install Arch Linux after you have booted on the official Arch Linux install media.

With this script, you can install Arch Linux with two simple terminal commands.

This wizard is made to install minimum packages (Base, bootloader and optionally archdi).

At the end of this wizard, you can install or launch archdi (Arch Linux Desktop Install) to install and configure desktop packages.

You can watch my videos to see how to use it here.

# How to use
First, boot with the last Arch Linux image with a bootable device.

Then make sure you have Internet connection on the Arch iso. If you have a wireless connection the iwctl command might be useful to you. You can also read the Network configuration from the Arch Linux guide for more detailed instructions.

Then download the script with from the command line:

```
curl -LO mikux-dev.github.io/archlinux-setup
```
Finally, launch the script:
```
sh ch-mod.sh
```
Then follow the on-screen instructions to completion.

If you require extra help, visit the provided video playlist and follow my example.
