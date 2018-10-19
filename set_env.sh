#!/bin/bash



##### Functions start

function print_this {

   printf '%.0s*' {1..100}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..100}; echo

}


function create_environment {

   # Make a backup of existing bashrc_linuxbrew file
   [ -f "$HOME/.bashrc_linuxbrew" ] && mv $HOME/.bashrc_linuxbrew $HOME/.bashrc_linuxbrew.$(date +%Y-%m-%d-%H:%M)

   # Write all the required ENV variables to a new bashrc_linuxbrew file
   echo "$ENV_VARIABLES" > $HOME/.bashrc_linuxbrew

   # Remove all the lines from bashrc file referencing "bashrc_linuxbrew". Following line also makes a backup of bashrc file
   sed -i.$(date +%Y-%m-%d-%H:%M) '/bashrc_linuxbrew/d' $HOME/.bashrc

   # Now append and make bashrc source newly generated bashrc_linuxbrew file
   echo 'source $HOME/.bashrc_linuxbrew' >> $HOME/.bashrc
   source $HOME/.bashrc

   print_this "Done setting env variables..."

}   # end of system_info



##### Functions End


if [ "$1" != "" ]; then
   INSTALLATION_PATH="$1"
else
   INSTALLATION_PATH="$PWD/$(date +%Y-%m-%d)"
fi



print_this "Setting env variables..."


ENV_VAR_NEEDED=(MANPATH INFOPATH SHARED_PATH HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE HTSLIB_DIR KENT_SRC MACHTYPE PERL5LIB PATH)


# Make a copy of all the current required env variables so that they can be restored later if required
for var in "${ENV_VAR_NEEDED[@]}"; do
   eval "${var}_tmp=\$$var" 
done


# Unset the current required env variables
for var in "${ENV_VAR_NEEDED[@]}"; do
   unset $var;
done


# Set PATH to minimal default
export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"



ENV_VARIABLES=$(cat << EOF
export INSTALLATION_PATH="$INSTALLATION_PATH"
export PATH="$INSTALLATION_PATH/paths:$INSTALLATION_PATH/linuxbrew/bin:$INSTALLATION_PATH/linuxbrew/sbin:$PATH"
export MANPATH="$INSTALLATION_PATH/linuxbrew/share/man:$MANPATH"
export INFOPATH="$INSTALLATION_PATH/linuxbrew/share/info:$INFOPATH"
export SHARED_PATH="$INSTALLATION_PATH/paths"

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


print_this "$ENV_VARIABLES"


if [ ! -z "$DISABLE_USER_INPUT_PROMPTS" ]; then
   
   create_environment

else 

   read -p "OK to set above env variables?: "  -n 1 -r
   echo

   case $REPLY in
        [Yy]* ) 	create_environment;;

        * )             # Restore all the previous env variables which were unset
      			for var in "${ENV_VAR_NEEDED[@]}"; do
        		   eval "export ${var}=\$${var}_tmp"
      			done
      			print_this "New env variables not set"
      			return;;

   esac


fi




