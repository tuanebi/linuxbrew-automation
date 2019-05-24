#!/bin/bash

##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}   

##### Functions end


# Check if 01-base.sh script is run successfully
if [ ! -f "$ENSEMBL_LINUXBREW_DIR/.base_libs_installed" ]; then
    print_this "Looks like there was a problem installting base libraries. Install base libraries before running this script. Aborting!"
    return
fi



if [ -z "$IS_A_DOCKER_INSTALL" ]; then

   read -p "Libraries will be installed into $ENSEMBL_LINUXBREW_DIR. Continue?: "  -n 1 -r
   echo

   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       print_this "Aborting installation!"
       return
   fi

fi




print_this "Installing Ensembl base libraries for gui"

time brew install ensembl/cask/web-gui

print_this "Installing Ensembl base libraries for bioinfo"

time brew install ensembl/cask/web-bifo

print_this "Installing Ensembl base libraries for internal purposes"

time brew install ensembl/cask/web-internal

# Create a file as a check for installing Perl modules and Python packages.
# Should we create an environment variable instead of this?
touch $ENSEMBL_LINUXBREW_DIR/.additional_libs_installed
