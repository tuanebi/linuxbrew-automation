#!/bin/bash

#echo $0;echo $1;echo $#;echo $@;echo $er;echo $?;if [ $? -eq 0 ];then echo "All OK"; else echo "something's wrong";fi; echo $$;


#set -o xtrace

#Check if current directory is empty

if [ $(find . -type d | wc -l) -gt  1 ]
  then
    read -p "Current directory is not empty. Continue?: "  -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
      then
        printf "\n%s\n" "Exiting"
        exit 1
     fi
fi

printf "\n%s\n" "****** Continuing... ******"

printf "\n%s\n" "****** Setting env variables... ******"

release_number="2018_08_01"
INSTALLATION_PATH="$PWD/$release_number"








unset MANPATH INFOPATH SHARE_PATH HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE HTSLIB_DIR KENT_SRC MACHTYPE PERL5LIB
export PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/sboddu/.local/bin:/home/sboddu/bin"



env_variables=$(cat << EOF
export PATH="$INSTALLATION_PATH/paths/bin:$INSTALLATION_PATH/linuxbrew/bin:$PATH"
export MANPATH="$INSTALLATION_PATH/linuxbrew/share/man:$MANPATH"
export INFOPATH="$INSTALLATION_PATH/linuxbrew/share/info:$INFOPATH"

export SHARE_PATH="$INSTALLATION_PATH/paths"

#Required for repeatmasker
export HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE="$INSTALLATION_PATH/ENSEMBL_MOONSHINE_ARCHIVE"

#Add bioperl to PERL5LIB
export PERL5LIB="$PERL5LIB:$INSTALLATION_PATH/linuxbrew/opt/bioperl-169/libexec"


# Setup Perl library dependencies
export HTSLIB_DIR="$INSTALLATION_PATH/linuxbrew/opt/htslib"
export KENT_SRC="$INSTALLATION_PATH/linuxbrew/opt/kent"
export MACHTYPE=x86_64 

EOF
)




#echo $env_variables
printf "%s\n\n" "$env_variables"

read -p "OK to set above env variables?: "  -n 1 -r

if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    printf "\n%s\n" "Exiting"
    exit 1
fi



eval "$env_variables"

printf "\n%s\n" "****** Done setting env variables... ******"


printf '\n%.0s' {1..5}


printf "%s\n\n" "****** Creating $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE dir ******"
mkdir -p $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE


printf "\n\n%s\n\n" "****** Clonning linuxbrew into $INSTALLATION_PATH/linuxbrew ******"
git clone https://github.com/Linuxbrew/brew.git $INSTALLATION_PATH/linuxbrew


printf "\n\n%s\n\n" "****** Turning off brew analytics ******"
brew analytics off

printf "\n\n%s\n\n" "****** Clonning 1000G into $INSTALLATION_PATH/1000G-tools ******"
git clone https://github.com/Ensembl/1000G-tools.git $INSTALLATION_PATH/1000G-tools


#printf "\n\n%s\n" "****** Clonning ensembl git tools into $INSTALLATION_PATH/ensembl-git-tools ******"
#git clone https://github.com/Ensembl/ensembl-git-tools.git $INSTALLATION_PATH/ensembl-git-tools


printf "\n\n%s\n\n" "****** Tapping Homebrew External, Homebrew Ensembl, Homebrew Web, Homebrew Moonshine and Homebrew Cask ******"


brew tap ensembl/external && \
brew tap ensembl/ensembl && \
brew tap ensembl/web && \
brew tap ensembl/moonshine && \
brew tap ensembl/cask





