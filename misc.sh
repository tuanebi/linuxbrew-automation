#!/bin/bash




if [[ -z $INSTALLATION_PATH || ! -d $INSTALLATION_PATH ]]; then
  printf "\n%s\n" "****** INSTALLATION_PATH is either not set or $INSTALLATION_PATH directory is empty ******"
  return
fi


printf "\n%s\n" "****** Setting up fonts ******"

if [[ -d '/usr/share/fonts/msttcore/' ]]; then
    ln -s /usr/share/fonts/msttcore ${INSTALLATION_PATH}/fonts
    printf "\n%s\n%s\n" "***** Microsoft True Type fonts found *****" "****** ln -s /usr/share/fonts/msttcore/ ${INSTALLATION_PATH}/fonts ******"
elif [[ -d '/usr/local/share/fonts/msttcore/' ]]; then
    ln -s /usr/local/share/fonts/msttcore/ ${INSTALLATION_PATH}/fonts
    printf "\n%s\n%s\n" "***** Microsoft True Type fonts found *****" "****** ln -s /usr/local/share/fonts/msttcore/ ${INSTALLATION_PATH}/fonts ******"
else 
    printf "\n%s\n" "****** Looks like Microsoft True Type fonts are not installed on your machine. Please install them before proceeding ******"
    return
fi



printf "\n%s\n" "****** Installing hubcheck and FileChameleon ******"

#At the moment, utils hosts hubcheck and FileChameleon
[ -d "$INSTALLATION_PATH/utils" ] || mkdir $INSTALLATION_PATH/utils
 
pushd $INSTALLATION_PATH/utils 
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/hubCheck
git clone https://github.com/Ensembl/format-transcriber.git
popd
ln -s ${INSTALLATION_PATH}/utils/format-transcriber/ ${INSTALLATION_PATH}/FileChameleon
