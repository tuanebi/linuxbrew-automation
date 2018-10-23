#!/bin/bash


#printf '\n%.0s' {1..5}


if [ -z "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR" ]; then
  printf "\n\n%s\n\n" "***** ENSEMBL_SOFTWARE_DEPENDENCIES_DIR is not set. Exiting! *****"
  exit 1
elif [ -d "$ENSEMBL_LINUXBREW_DIR" ]; then
  printf "\n\n%s\n\n" "**** Looks like linuxbrew directory already exists. Exiting! *****"
  exit 1
else
  read -p "Linuxbrew will be installed into $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR. Continue?: "  -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    [ -d "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR" ] || mkdir $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR
  else
    printf "\n\n%s\n\n" "****** Aborting! ******"
    exit 1
  fi
fi
 
  


printf "\n\n%s\n\n" "****** Clonning linuxbrew into $ENSEMBL_LINUXBREW_DIR ******"
git clone https://github.com/Linuxbrew/brew.git $ENSEMBL_LINUXBREW_DIR


printf "\n\n%s\n\n" "****** Turning off brew analytics ******"
brew analytics off

printf "\n\n%s\n\n" "****** Clonning 1000G into $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/1000G-tools ******"
git clone https://github.com/Ensembl/1000G-tools.git $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/1000G-tools


printf "%s\n\n" "****** Creating $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE dir ******"
mkdir -p $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE

#printf "\n\n%s\n" "****** Clonning ensembl git tools into $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/ensembl-git-tools ******"
#git clone https://github.com/Ensembl/ensembl-git-tools.git $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/ensembl-git-tools


printf "\n\n%s\n\n" "****** Tapping Homebrew External, Homebrew Ensembl, Homebrew Web, Homebrew Moonshine and Homebrew Cask ******"


brew tap ensembl/external && \
brew tap ensembl/ensembl && \
brew tap ensembl/web && \
brew tap ensembl/moonshine && \
brew tap ensembl/cask


brew install ensembl/cask/web-base


#Remove binaries which are symlinked to system binaries and linking them back to brew binaries. We need to find these binaries dynamically rather than hardcoding. Patchelf is linking them to system binaries?

rm  ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/g++-4.8 ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gcc-4.8  ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gfortran-4.8
ln -s ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/g++ ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/g++-4.8
ln -s ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gcc ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gcc-4.8
ln -s ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gfortran ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/linuxbrew/bin/gfortran-4.8


brew install ensembl/cask/web-libsforcpanm
brew install ensembl/cask/web-gui
brew install ensembl/cask/web-bifo
brew install ensembl/cask/web-internal




#hdf5@1.8(hal dependency) is keg-only and hence linking is not done. Force link it.
brew link --force hdf5@1.8






