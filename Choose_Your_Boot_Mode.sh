#!/bin/bash
# This does not need sudo
# This does not need read-only disabled

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
echo "|- ${bold}Tutorials on Steam Deck - Changing persistent boot mode on SteamOS v0.1 -${reset}"
echo "|"
echo "| Written on 4/4/23 and tested on SteamOS:"
echo "|     - version 3.4.6 - build 20230302.1"
echo "| Your version will likely work too but there are NO guarentees. Valve may change how things work in future updates."
echo "|"
echo "|"
echo "| This script just presents 3 persistent boot options to choose from."
echo "|"
echo "|"
echo "|     ${bold}How It Works:${reset}"
echo "|"
echo "| Type the number corrisponding with your choice of persistent boot and press 'enter'."
echo "|"
echo "|     Option 1) Gaming Mode is the default mode for Steamdeck."
echo "|     Option 2) Desktop Mode using X11 (XORG) - When you switch to desktop from gaming mode, it uses x11 by default."
echo "|     Option 3) Desktop Mode using WAYLAND - Wayland is much smoother and great for different sized external displays but it may do something quirky here or there."
echo "|"
echo "|"
echo "| ${yellow}Warning - The Steamdeck will immediately reboot upon selecting an option. Please make sure you aren't doing something important and save all your work.${reset}"
echo "---------------------------------------------------------------------------"
echo ""
echo ""
PS3="[Please type the # of your selection and hit 'Enter']: "

items=("1) Gaming Mode (the default)" "2) Desktop Mode (X11)" "3) Desktop Mode (Wayland)")

while true; do
    select item in "${items[@]}" Quit
    do
        case $REPLY in
            1)
                steamos-session-select gamescope; break;;
            2)
                steamos-session-select plasma-x11-persistent; break;;
            3)
                steamos-session-select plasma-wayland-persistent; break;;

            $((${#items[@]}+1))) echo "Exiting"; break 2;;
            *) echo "
                    ${red}Invalid option: $REPLY"${reset}; break;
        esac
    done
done
