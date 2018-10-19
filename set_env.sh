#!/bin/bash



##### Functions start

function print_this {

   printf '%.0s*' {1..100}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..100}; echo

}   # end of print_this


function create_new_environment {

   # Make a backup of existing bashrc_linuxbrew file
   [ -f "$HOME/.bashrc_linuxbrew" ] && mv $HOME/.bashrc_linuxbrew $HOME/.bashrc_linuxbrew.$(date +%Y-%m-%d-%H:%M)

   # Write all the required ENV variables to a new bashrc_linuxbrew file
   echo "$ENV_VARIABLES" > $HOME/.bashrc_linuxbrew

   # Remove all the lines from bashrc file referencing "bashrc_linuxbrew". Following line also makes a backup of bashrc file
   sed -i.$(date +%Y-%m-%d-%H:%M) '/bashrc_linuxbrew/d' $HOME/.bashrc

   # Now append and make bashrc source newly generated bashrc_linuxbrew file
   echo 'source $HOME/.bashrc_linuxbrew' >> $HOME/.bashrc
   source $HOME/.bashrc

   print_this "Done setting environment variables..."

}   # end of create_new_environment 


function backup_environment_variables {

   # Make a copy of all the current required environment variables so that they can be restored later if required
   for var in "${ENV_VAR_NEEDED[@]}"; do
      eval "${var}_tmp=\$$var"
      #eval "echo \$$var"
      #eval "echo \$${var}_tmp"
   done

   print_this "Made a backup of current environment variables"

}   # End of backup_environment_variables



function unset_current_environment_variables{

   # Unset the current required environment variables	
   for var in "${ENV_VAR_NEEDED[@]}"; do	
     unset $var;	
   done

   # Set PATH to minimal default
   export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"

}   # End of unset_current_environment_variables

function restore_environment_variables_from_backup {

   # Restore all the previous environment variables which were unset
   for var in "${ENV_VAR_NEEDED[@]}"; do
      eval "export ${var}=\$${var}_tmp"
   done
   
   print_this "Previous environment variables restored"

}  # End of restore_environment_variables_from_backup 


##### Functions End






######################################################################################################################
#
#
#                            CREATE ENVIRONMENT FOR BREW INSTALLATION
#
#
######################################################################################################################


if [ "$1" != "" ]; then
   INSTALLATION_PATH="$1"
else
   INSTALLATION_PATH="$PWD/$(date +%Y-%m-%d)"
fi


ENV_VAR_NEEDED=(MANPATH INFOPATH SHARED_PATH HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE HTSLIB_DIR KENT_SRC MACHTYPE PERL5LIB PATH)

backup_environment_variables

print_this "Setting new environment variables..."


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
   
   create_new_environment

else 

   read -p "OK to set above environment variables?: "  -n 1 -r
   echo

   case $REPLY in
        [Yy]* ) 	unset_current_environment_variables
			create_new_environment;;

        * )             restore_environment_variables_from_backup
      			return;;

   esac


fi




######################################################################################################################
#
#
#                                     INSTALL BASE LIBRARIES
#
#
######################################################################################################################





if [ -z "$INSTALLATION_PATH" ]; then
    print_this "INSTALLATION_PATH is not set. Exiting!"
    return
fi




if [ -z "$DISABLE_USER_INPUT_PROMPTS" ]; then


   if [ -d "$INSTALLATION_PATH/linuxbrew" ]; then
      read -p "Looks like linuxbrew directory already exists. Continue installing into the existing directory?: "  -n 1 -r
      echo

      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
         restore_environment_variables_from_backup
         print_this "Aborting!"
         return
      fi

   fi


   read -p "Linuxbrew will be installed into $INSTALLATION_PATH. Continue?: "  -n 1 -r

   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       restore_environment_variables_from_backup
       print_this "Aborting!"
       return
   fi

fi


[ -d "$INSTALLATION_PATH" ] || mkdir $INSTALLATION_PATH


