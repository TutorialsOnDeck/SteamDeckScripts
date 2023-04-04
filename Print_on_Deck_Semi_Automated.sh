#!/bin/bash
# this requires super user to work
# this requires disabling read only

red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
yellow=$'\e[1;93m'
white=$'\e[0m'
bold=$'\e[1m'
norm=$'\e[21m'
reset=$'\e[0m'

doestpmexist=$(grep -F "module_blacklist=tpm" "/etc/default/grub" | wc -l)
isdmcryptloaded=$(lsmod | grep dm_crypt | wc -l)
clear
echo "---------------------------------------------------------------------------"
echo "|- ${bold}Tutorials on Steam Deck - Enable Printing Support v0.1 -${reset}"
echo "|"
echo "| Written on 4/4/23 and tested on SteamOS:"
echo "|     - version 3.4.6 - build 20230302.1"
echo "| Your version will likely work too but there are NO guarentees. Valve may change how things work in future updates."
echo "|"
echo "|"
echo "| This script will go through everything needed to get a linux supported printer to work on SteamDeck. Ultimately if your printer manufacturer does not support linux, you are out of luck."
echo "| Do a quick search on your printer manufacturer's website under driver downloads. If Linux is mentioned (can be ubuntu, debian, fedora, etc) It is worth trying."
echo "|"
echo "|     ${bold}Requirements:${reset}"
echo "|"
echo "|  - A password configured for the 'deck' user. We need a password to run 'sudo'"
echo "|  - SteamOS will need it's Read-Only mode disabled"
echo "|  - An internet Connection is required for downloading files"
echo "|  - Your printer needs to be compatible with linux"
echo "|  - A keyboard and mouse is already helpful"
echo "|"
echo "|     ${bold}What This Script Does:${reset}"
echo "|"
echo "|  1) Checks that a password is configured for the 'deck' user. If no password is found, prompts to create one."
echo "|  2) Disables the read-only mode of SteamOS"
echo "|  3) Initiates and populates gpg keys for pacman to use"
echo "|  4) Check for printer related files already on the steamdeck and make a backup of them. It does this to prevent pacman from cancelling the installation by seeing these old files."
echo "|  5) Updates repository list and downloads / installs the required printer packages."
echo "|  6) Enables and starts the needed systemd services for printing."
echo "|  7) If older files were found, it will overwrite the new files with your original files. This may save you having to set up the printers again after a SteamOS update."
echo "|  8) Starts the 'configure printer' application for you."
echo "|"
echo "|"
echo "| ${yellow}Warning 1 - Because we are creating / manupulating files on rootfs, these changes will be lost after a SteamOS update. You will need to redo all of these steps after each update.${reset}"
echo "| ${yellow}Warning 2 - If you have already installed printer support before and you re-run this script, you will likely be met with a (conflicting file) error and Pacman will fail to work. THis is because files Pacman needs to write to your drive already exist and out of caution, it won't overwrite them... unless forced using -f. This is a solution... but I HIGHLY DISCOURAGE using -f. Even the pacman developers say 'Don't use it!'${reset}"
echo "---------------------------------------------------------------------------"
echo ""
echo ""
read -p "${bold}    When you are done reading the above and are ready to begin, press 'Enter'${reset}"
echo ""
echo "Checking for user password."
if [[ $(passwd --status "$USER" | awk '{print $2}') = NP ]]
    then
        echo "${bold}WARNING - You don't have a password set! You need to set a password for using the 'sudo' command.${reset}"
        echo "Please think of a memorable password; it doesn't have to be long or complicated. It could even be a single letter or number."
        echo "Write it down on some paper, keep that copy in your deck's carry case; it will save you having to factory reset because you forgot it."
        # I am aware there are other ways to reset your user password.
        echo "Now enter the password on the deck below. Then enter it a second time. Afterwards, we can continue."
        passwd
fi
echo ""
echo "Please enter your user password."
echo ""
sudo echo ""
echo ""
echo ""
echo "Disabling SteamOS Read-Only Mode"
echo ""
sudo steamos-readonly disable
echo ""
echo ""
echo "Updating Pacman gpg keys"
echo ""
sudo pacman-key –init
sudo pacman-key –populate archlinux holo
echo ""
echo ""
echo "Making backups of any old printer files. This will prevent pacman from cancelling an install if you already installed printer support before. Any errors are OK, it just means it didn't find the files."
echo ""
sudo mv -v /etc/cups/cups-files.conf.default /etc/cups/cups-files.conf.default.old
sudo mv -v /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf.default.old
sudo mv -v /etc/cups/snmp.conf.default /etc/cups/snmp.conf.default.old
sudo mv -v /etc/cupshelpers/preferreddrivers.xml /etc/cupshelpers/preferreddrivers.xml.old
sudo mv -v /etc/xdg/autostart/print-applet.desktop /etc/xdg/autostart/print-applet.desktop.old
echo ""
echo ""
echo "${yellow}READ ME${reset}"
echo "If you have already set up Pacman prior to this script, and done something like enable chaotic AUR, you may encounter conflicts which you should resolve manually."
echo "If you have already installed printers before and are using this script to quickly re-install, pacman may detect an old file, and for safety, cancel the install. My script will detect and move some old files to prevent this, but I only have a couple printers to test with, so your printer may have files I do not and still cause a failure. Just remove the conflicting old file (pacman will tell you what files it found and didn't want to overwrite) and re-run this script."
echo ""
read -p "${bold}    When you are done reading the above and are ready to continue, press 'Enter'${reset}"
echo ""
echo ""
echo "Installing packages. You shouldn't be asked for input but who knows..."
echo ""
sudo pacman --noconfirm -Sy cups cups-pdf system-config-printer sane evince
echo ""
echo ""
echo "Starting all needed printer services"
echo ""
sudo systemctl enable --now avahi-daemon.service
sudo systemctl enable --now cups.service
sudo systemctl enable --now cups.path
echo ""
echo ""
echo "Starting the printer manager application. This is where you are on your own as there are hundreds of different printers."
echo " Note: if you installed a firewall on the steamdeck (there is none installed by Valve) You will need to set rules for mdns, ipp and ipp-client."
system-config-printer > /dev/null 2>&1
