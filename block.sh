#!/bin/bash
# Script to install social media distraction prevention program
# Developed by Subin Gyawali

# Directory to install the program, you can change this to install files in your custom directory
INSTALL_PATH='/etc/'

# Function to check if all prerequisites are fulfilled
checkDependencies(){
    tput setaf 3
    tput bold
    printf "\nChecking and Installing dependencies...\n"
    tput sgr0   
    # installing required packages
    sudo apt-get install sed cron
    tput setaf 2
    tput bold
    printf "\nDependencies installed!\n"
    tput sgr0
    installFolders
}

# Function to create files and folders
installFolders(){
    tput setaf 3
    tput bold
    printf "\nCreating files...\n"
    tput sgr0 
    # Making directory to hold the files
    sudo mkdir -p "${INSTALL_PATH}focused-linux"
    # Copying block and unblock scripts to the installation directory
    sudo cp block.sh unblock.sh "${INSTALL_PATH}focused-linux"
    # Making list file to hold sites' list to block
    FULL_PATH="${INSTALL_PATH}focused-linux/sites-list"

    # Checking if the list file already exists 
    if [ -f "$FULL_PATH" ]; then
        # changing the file permission
        sudo chmod 777 "${FULL_PATH}"
        # Opening file in nano editor to allow editing
        sudo nano "${FULL_PATH}"    
        tput setaf 3
        tput bold
        printf "\nConfiguring Files...\n"
        # calling function to configure files
        configureFiles
    else 
        sudo touch "${FULL_PATH}"
        # changing the file permission
        sudo chmod 777 "${FULL_PATH}"
        # Setting some default configurations for the files
        sudo printf "# This file holds the list of the sites you want to block\n# Add the domain name of the sites you want to block\n\n# Some of the most popular distraction sites have been configured by default\n# You can remove existing default sites if you want\n# If you do not want to edit this file, just save and exit the editor\n\n# Default Sites\n\n" >> "${FULL_PATH}"
        sudo printf "facebook.com\ntwitter.com\ninstagram.com\nyoutube.com\nnetflix.com\nhulu.com\ntwitch.tv\npinterest.com\ntumblr.com\nvimeo.com\nlinkedin.com\nquora.com\ntinder.com\n\n" >> "${FULL_PATH}"
        sudo printf "# Add your sites after this line (one site in each line)" >> "${FULL_PATH}"
        tput setaf 2
        tput bold
        printf "\nFiles Created!\n"
        tput setaf 3
        printf "\nOpening your sites list in the editor...\n"
        tput sgr0
        # Opening file in nano editor to allow editing
        sudo nano "${FULL_PATH}"    
        tput setaf 3
        tput bold
        printf "\nConfiguring Files...\n"
        # calling function to configure files
        configureFiles 
    fi
}

configureFiles(){
    # Removing temp file if already exits
    sudo rm -rf "${INSTALL_PATH}focused-linux/temp"
    # Creating temp file to store dns entries temporarily
    sudo touch "${INSTALL_PATH}focused-linux/temp"
    # copying sites from sites-list
    sudo grep '\.' "${FULL_PATH}" >> "${INSTALL_PATH}focused-linux/temp"
    # Adding dns entry for each site
    sudo sed -i 's/^/0.0.0.0 /g' "${INSTALL_PATH}focused-linux/temp"
    # Removing dns entries on hosts file if already exist
    sudo sed -i "/^0.0.0.0/d" '/etc/hosts'
    # Removing dns entries on hosts file if already exist
    sudo sed -i "/^::\/0/d" '/etc/hosts'
    # Copying configured dns entries to hosts file
    sudo cat "${INSTALL_PATH}focused-linux/temp" >> '/etc/hosts'
    # Replacing IP for IPv6 address
    sudo sed -i "s/0.0.0.0/::\/0/g" "${INSTALL_PATH}focused-linux/temp"
    # Copying configured IPv6 dns entries to hosts file
    sudo cat "${INSTALL_PATH}focused-linux/temp" >> '/etc/hosts'
    # Removing temp file after copying the dns entries
    sudo rm -rf "${INSTALL_PATH}focused-linux/temp"    
    tput setaf 2
    tput bold
    printf "\nConfiguration Successfull!\nAll of your entered sites were blocked.\n\nIf not working, clear your browser caches.\n\n"
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
    printf "\nConfiguring Focused Linux on your system..\n"
    tput sgr0
    # calling function to check for dependencies
    checkDependencies
fi

# Developed by Subin Gyawali