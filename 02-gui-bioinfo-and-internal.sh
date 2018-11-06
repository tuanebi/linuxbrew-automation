#!/bin/bash

##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}   

##### Functions end


# Check if 01-base.sh script is run successfully
if [ ! -f "$ENSEMBL_LINUXBREW_DIR/.base_installation_completed" ]; then
    print_this "Looks like there was a problem installting base libraries. Install base libraries before running this script. Aborting!"
    return
fi

print_this "Installing Ensembl base libraries for gui"

time brew install ensembl/cask/web-gui

print_this "Installing Ensembl base libraries for bioinfo"

time brew install ensembl/cask/web-bifo

print_this "Installing Ensembl base libraries for internal purposes"

time brew install ensembl/cask/web-internal



brew link --force hdf5@1.8
