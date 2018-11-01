#!/bin/bash

##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}   

##### Functions end

print_this "Installing Ensembl base libraries for gui"

time brew install ensembl/cask/web-gui

print_this "Installing Ensembl base libraries for bioinfo"

time brew install ensembl/cask/web-bifo

print_this "Installing Ensembl base libraries for internal purposes"

time brew install ensembl/cask/web-internal



brew link --force hdf5@1.8
