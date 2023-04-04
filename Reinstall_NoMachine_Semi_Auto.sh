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

clear
echo "---------------------------------------------------------------------------"
echo "|- ${bold}Tutorials on Steam Deck - Install Latest NoMachine on SteamOS v0.1 -${reset}"
echo "|"
echo "| Written on 4/3/23 and tested on SteamOS:"
echo "|     - version 3.4.6 - build 20230302.1"
echo "| Your version will likely work too but there are NO guarentees. Valve may change how things work in future updates."
echo "|"
echo "|"
echo "| This script will Automatically download and install the latest version of NoMachine on SteamOS."
echo "|"
echo "| ${yellow}REQUIREMENTS${reset}"
echo "|"
echo "| - You will need to set up a password for your deck's user account so we can use the 'sudo' command."
echo "| - We need to temporarily disable the read-only property of SteamOS to install noMachine inside the /usr/ folder."
echo "|"
echo "|"
echo "| ${yellow}Steps This Script Performs${reset}"
echo "|"
echo "|  1) Disables the Read Only property of SteamOS"
echo "|  2) Uses 'wget' to download the latest nomachine version as 'nomachine.tar.gz into /home/deck/Downloads/"
echo "|  3) Extracts the downloaded tar.gz into /usr/ and deletes the now uneccesary .tar.gz to save ever precious space on your deck."
echo "|  4) Initiates the install of NoMachine to the /usr/NX/ folder."
echo "|  5) Runs NoMachine after installing, barring no serious error broke the install. There is no 'official' version of nomachine for SteamOS / Arch"
echo "|"
echo "|"
echo "| If you already installed NoMachine and used it prior to this installation, all your settings will exist, as NoMachine keeps its configuration files in your home directory."
echo "|"
echo "|"
echo "| ${yellow}REQUIRED - You will need 'sudo' priveledges to run this script, so please ensure you have a password already set for your user account. Input the user password when prompted.${reset}"
echo "---------------------------------------------------------------------------"
echo ""
echo ""
read -p "${bold}    When you are done reading the above and are ready to begin, press 'Enter'${reset}"
echo ""
echo "Please enter your user password."
sudo echo ""

echo ""
echo "Disabling (temporarily) the read only mode for SteamOS"
sudo steamos-readonly disable
echo ""
echo "Downloading the latest NoMachine installer to /home/deck/Downloads/"
wget -O /home/deck/Downloads/nomachine.tar.gz https://www.nomachine.com/free/linux/64/
echo ""
echo "Extracting the nomachine.tar.gz just downloaded into /usr/"
sudo tar zxvf /home/deck/Downloads/nomachine.tar.gz -C /usr/
echo ""
echo "Removing the now uneccesary nomachine download to save 53mb of space on your steam deck! Oh Boy!"
rm /home/deck/Downloads/nomachine.tar.gz
echo ""
echo "Running the NoMachine installer. There will be errors shown; it happened in all my testing, however, NoMachine works fine."
sudo /usr/NX/nxserver --install redhat
echo ""
echo "Re-enabling read only mode for SteamOS"
sudo steamos-readonly enable
echo ""
echo "Starting NoMachine"
/usr/NX/bin/nxplayer
echo ""
echo ""
read -p "${bold}    All set, barring any install error, noMachine should be running now. When you are done reading, press 'Enter'${reset}"


