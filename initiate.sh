#!/bin/bash

#echo $0;echo $1;echo $#;echo $@;echo $er;echo $?;if [ $? -eq 0 ];then echo "All OK"; else echo "something's wrong";fi; echo $$;



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

printf "\n%s\n" "Continuing..."

printf "\n%s\n" "Setting env variables..."

release_number="2018_06_05"
INSTALLATION_PATH="$PWD/$release_number"


env_variables=$(cat << EOF
export PATH="$INSTALLATION_PATH/linuxbrew/bin:$PATH"
export PATH="$INSTALLATION_PATH/paths/bin:$PATH"
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



