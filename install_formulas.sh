#!/bin/bash


#printf '\n%.0s' {1..5}


if [ -z "$INSTALLATION_PATH" ]; then
  printf "\n\n%s\n\n" "***** INSTALLATION_PATH is not set. Exiting! *****"
  exit 1
elif [ -d "$INSTALLATION_PATH/linuxbrew" ]; then
  printf "\n\n%s\n\n" "**** Looks like linuxbrew directory already exists. Exiting! *****"
  exit 1
else
  read -p "Linuxbrew will be installed into $INSTALLATION_PATH. Continue?: "  -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    [ -d "$INSTALLATION_PATH" ] || mkdir $INSTALLATION_PATH
  else
    printf "\n\n%s\n\n" "****** Aborting! ******"
    exit 1
  fi
fi
 
  


printf "\n\n%s\n\n" "****** Clonning linuxbrew into $INSTALLATION_PATH/linuxbrew ******"
git clone https://github.com/Linuxbrew/brew.git $INSTALLATION_PATH/linuxbrew


printf "\n\n%s\n\n" "****** Turning off brew analytics ******"
brew analytics off

printf "\n\n%s\n\n" "****** Clonning 1000G into $INSTALLATION_PATH/1000G-tools ******"
git clone https://github.com/Ensembl/1000G-tools.git $INSTALLATION_PATH/1000G-tools


printf "%s\n\n" "****** Creating $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE dir ******"
mkdir -p $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE

#printf "\n\n%s\n" "****** Clonning ensembl git tools into $INSTALLATION_PATH/ensembl-git-tools ******"
#git clone https://github.com/Ensembl/ensembl-git-tools.git $INSTALLATION_PATH/ensembl-git-tools


printf "\n\n%s\n\n" "****** Tapping Homebrew External, Homebrew Ensembl, Homebrew Web, Homebrew Moonshine and Homebrew Cask ******"


brew tap ensembl/external && \
brew tap ensembl/ensembl && \
brew tap ensembl/web && \
brew tap ensembl/moonshine && \
brew tap ensembl/cask


brew install ensembl/cask/web-base


#Remove binaries which are symlinked to system binaries and linking them back to brew binaries. We need to find these binaries dynamically rather than hardcoding. Patchelf is linking them to system binaries?

rm  ${INSTALLATION_PATH}/linuxbrew/bin/g++-4.8 ${INSTALLATION_PATH}/linuxbrew/bin/gcc-4.8  ${INSTALLATION_PATH}/linuxbrew/bin/gfortran-4.8
ln -s ${INSTALLATION_PATH}/linuxbrew/bin/g++ ${INSTALLATION_PATH}/linuxbrew/bin/g++-4.8
ln -s ${INSTALLATION_PATH}/linuxbrew/bin/gcc ${INSTALLATION_PATH}/linuxbrew/bin/gcc-4.8
ln -s ${INSTALLATION_PATH}/linuxbrew/bin/gfortran ${INSTALLATION_PATH}/linuxbrew/bin/gfortran-4.8


brew install ensembl/cask/web-libsforcpanm
brew install ensembl/cask/web-gui
brew install ensembl/cask/web-bifo
brew install ensembl/cask/web-internal




#hdf5@1.8(hal dependency) is keg-only and hence linking is not done. Force link it.
brew link --force hdf5@1.8






