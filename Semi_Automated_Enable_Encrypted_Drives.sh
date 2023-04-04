#!/bin/bash
# this requires super user to work
# this does Not require disabling read only

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
echo "|- ${bold}Tutorials on Steam Deck - Enable mounting encrypted drives on SteamOS v0.1 -${reset}"
echo "|"
echo "| Written on 4/3/23 and tested on SteamOS:"
echo "|     - version 3.4.6 - build 20230302.1"
echo "| Your version will likely work too but there are NO guarentees. Valve may change how things work in future updates."
echo "|"
echo "|"
echo "| This script checks to see if ${red}module_blacklist=tpm${reset} exists in the current GRUB file. It then chooses either path A or path B and applies changes accordingly."
echo "|"
echo "| ${yellow}You will need to run this script twice${reset}, once to complete Path A, then after the steamdeck reboots, to complete Path B."
echo "|"
echo "|"
echo "|     ${bold}How It Works:${reset}"
echo "|"
echo "| If 'module_blacklist=tpm' DOES exist in /etc/default/grub, then it chooses Path A:"
echo "|"
echo "| Path A:"
echo "|  1) Creates a copy of the current GRUB config as a backup. This is saved at /etc/default/grub_backup."
echo "|  2) Removes the 'module_blacklist=tpm' line from the GRUB config file"
echo "|  3) Runs the 'update-grub' command (thank you Valve for including this) and creates a log file at /etc/default/grub_log.txt"
echo "|  4) Initiates a reboot that automatically goes back into desktop mode"
echo "|"
echo "|"
echo "| If 'module_blacklist=tpm' does ${red}NOT${reset} exist in /etc/default/grub then it chooses Path B:"
echo "|"
echo "| Path B:"
echo "|  1) Runs 'modprobe dm_crypt' which loads... dm_crypt... into the linux kernel"
echo "|  2) tests to see if the 'dm_crypt' module was loaded successfully"
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



if [[  $doestpmexist -ge 1  ]]
    then
        echo "making a backup of the default GRUB file in case something goes wrong. The file is called grub_backup and is under /etc/default/"
        sudo cp -v /etc/default/grub /etc/default/grub_backup
        echo ""

        echo "Removing the command 'module_blacklist=tpm' in /etc/default/grub file"
        sudo sed -i -e 's/module_blacklist=tpm //g' /etc/default/grub
        # I am aware I can do both a backup and edit in one command: sed --in-place=.backup 's/module_blacklist=tpm //g' /etc/default/grub
        echo ""

        echo "Updating GRUB with the new changes. You may see some warnings, they are probably OK... but just in case, a log file will be located at /etc/default/grub_log.txt"
        echo ""
        sudo update-grub | sudo tee /etc/default/grub_log.txt
        echo ""
        echo ""

        echo "We need to reboot the steamdeck to apply the changes. You will need to return to desktop mode and re-run this script one more time after the reboot."
        echo ""
        read -p "${bold}When you are ready to reboot, please press 'Enter'${reset}"
        reboot
    else
        echo "Loading the dm_crypt module into the linux kernel"
        sudo modprobe -v dm_crypt
        echo ""

        echo "Verifying dm_crypt is loading..."
        echo ""
        if [[  "$isdmcryptloaded" -ge "1"  ]]
            then
                echo "'dm_crypt' appears to be loaded successfully. Try using an encrypted drive and see if it mounts."
                echo ""
            else
                echo "dm_crypt loading failed? See the message output above and do a quick internet search. Perhaps Valve or Arch Linux made a change that broke my script. Email me at TutorialsOnSteamDeck@gmail.com and let me know so I can check into it. Copy and paste all the above output into the email."
                echo ""
                echo ""
        fi
fi
