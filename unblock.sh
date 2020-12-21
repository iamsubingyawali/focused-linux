#!/bin/bash
# Script to uninstall social media distraction prevention program
# Developed by Subin Gyawali

removeFiles(){
    # Removing Default installation directory
    sudo rm -rf '/etc/focused-linux/'
    # Removing dns entries on hosts file 
    sudo sed -i "/^0.0.0.0/d" '/etc/hosts'
    # Removing dns entries on hosts file 
    sudo sed -i "/^::\/0/d" '/etc/hosts'
    tput setaf 2
    tput bold
    printf "\nFiles Removed!\n\nRun block.sh again if you wish to reconfigure Focused Linux."
    tput sgr0
}

# Checking if user is root
if [[ $EUID -ne 0 ]] 
then
    tput setaf 1
    tput bold
    printf "\nThis program requires root privileges to run.\nPlease run this program as root.\n"
else
    tput setaf 3
    tput bold
    printf "\nRemoving Files..\n"
    tput sgr0
    # calling function to check for dependencies
    removeFiles
fi

# Developed by Subin Gyawali