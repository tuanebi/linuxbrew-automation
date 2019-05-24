#!/bin/bash



##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}   # end of print_this


function backup_environment_variables {

   # Make a copy of all the current required environment variables so that they can be restored later if required
   for var in "${ENV_VAR_NEEDED[@]}"; do
      eval "${var}_tmp=\$$var"
      #eval "echo \$$var"
      #eval "echo \$${var}_tmp"
   done

   print_this "Made a backup of current environment variables"

}   # End of backup_environment_variables



function unset_current_environment_variables {

   # Unset the current required environment variables
   for var in "${ENV_VAR_NEEDED[@]}"; do
     unset $var;
   done

   # Set PATH to minimal default
   export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"

}   # End of unset_current_environment_variables



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



function restore_environment_variables_from_backup {

   # Restore all the previous environment variables which were unset
   for var in "${ENV_VAR_NEEDED[@]}"; do
      eval "export ${var}=\$${var}_tmp"
   done

   #######################################################################
   #Should we add logic to restore bashrc and bashrc_linuxbrew file here?#
   #######################################################################

   
   print_this "Previous environment variables restored. Please restore bashrc and bashrc_linuxbrew files from backup."

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
   ENSEMBL_SOFTWARE_DEPENDENCIES_DIR="$1"
else
   ENSEMBL_SOFTWARE_DEPENDENCIES_DIR="$PWD/$(date +%Y-%m-%d)"
fi


# IS_A_DOCKER_INSTALL variable is set in the Dockerfile and used while installing libraries using docker. For such docker installations, to avoid build timeout on Docker Hub, we need to install packages under /home/linuxbrew/.linuxbrew directory for brew to install packages from bottles rather than falling back to installing from source for a *few packages*.
#For more info, see: https://github.com/Linuxbrew/brew/wiki/FAQ

if [ ! -z "$IS_A_DOCKER_INSTALL" ]; then
   ENSEMBL_LINUXBREW_DIR="/home/linuxbrew/.linuxbrew"
else
   ENSEMBL_LINUXBREW_DIR="$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/linuxbrew"
fi




ENV_VAR_NEEDED=(MANPATH INFOPATH SHARED_PATH HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE HTSLIB_DIR KENT_SRC MACHTYPE PERL5LIB PATH)

backup_environment_variables

print_this "Setting new environment variables..."

ENV_VARIABLES=$(cat << EOF
export ENSEMBL_SOFTWARE_DEPENDENCIES_DIR="$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR"
export ENSEMBL_LINUXBREW_DIR="$ENSEMBL_LINUXBREW_DIR"
export PATH="$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/paths:$ENSEMBL_LINUXBREW_DIR/bin:$ENSEMBL_LINUXBREW_DIR/sbin:\$PATH"
export MANPATH="$ENSEMBL_LINUXBREW_DIR/share/man:\$MANPATH"
export INFOPATH="$ENSEMBL_LINUXBREW_DIR/share/info:\$INFOPATH"
export SHARED_PATH="$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/paths"

#Required for repeatmasker
export HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE="$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/ENSEMBL_MOONSHINE_ARCHIVE"

#Add bioperl to PERL5LIB
export PERL5LIB="\$PERL5LIB:$ENSEMBL_LINUXBREW_DIR/opt/bioperl-169/libexec"

# Setup Perl library dependencies
export HTSLIB_DIR="$ENSEMBL_LINUXBREW_DIR/opt/htslib"
export KENT_SRC="$ENSEMBL_LINUXBREW_DIR/opt/kent"
export MACHTYPE=x86_64 

# Add PYTHONPATH for posgap
export PYTHONPATH="$PYTHONPATH:/nfs/public/release/ensweb-software/sharedsw/2019_02_07/postgap/lib/"

# Other brew variables
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1  

EOF
)


print_this "$ENV_VARIABLES"


if [ ! -z "$IS_A_DOCKER_INSTALL" ]; then
   
   create_new_environment

else 

   read -p "OK to set above environment variables?: "  -n 1 -r
   echo

   if [[ $REPLY =~ ^[Yy]$ ]]; then
      unset_current_environment_variables
      create_new_environment
   else
      print_this "Aborting!"
      return
   fi

fi




######################################################################################################################
#
#
#                                     INSTALL BASE LIBRARIES
#
#
######################################################################################################################





if [ -z "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR" ]; then
    print_this "ENSEMBL_SOFTWARE_DEPENDENCIES_DIR is not set. Exiting!"
    return
fi




if [ -z "$IS_A_DOCKER_INSTALL" ]; then


   if [ -d "$ENSEMBL_LINUXBREW_DIR" ]; then
      read -p "Looks like linuxbrew directory already exists. Continue installing into the existing directory?: "  -n 1 -r
      echo

      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
         restore_environment_variables_from_backup
         print_this "Aborting!"
         return
      fi

   fi


   read -p "Linuxbrew will be installed into $ENSEMBL_LINUXBREW_DIR. Continue?: "  -n 1 -r
   echo

   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       restore_environment_variables_from_backup
       print_this "Aborting!"
       return
   fi

fi


[ -d "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR" ] || mkdir $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR


print_this "Clonning linuxbrew into $ENSEMBL_LINUXBREW_DIR"
git clone https://github.com/Linuxbrew/brew.git $ENSEMBL_LINUXBREW_DIR


print_this "Turning off brew analytics"
brew analytics off

print_this "Clonning 1000G into $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/1000G-tools"
git clone https://github.com/Ensembl/1000G-tools.git $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/1000G-tools


print_this "Creating $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE directory"
mkdir -p $HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE


print_this "Tapping Homebrew External, Homebrew Ensembl, Homebrew Web, Homebrew Moonshine and Homebrew Cask"
brew tap tuanebi/external && \
#brew tap ensembl/ensembl && \
brew tap ensembl/web && \
brew tap ensembl/moonshine && \
brew tap ensembl/cask
brew tap denji/nginx



###################### FREEZE BREW AND HOMEBREW CORE FOR RELEASE 95 TO AVOID SURPRISES IN CASE USERS WANT TO BUILD THEIR OWN IMAGES ################################

pushd $ENSEMBL_LINUXBREW_DIR
git checkout 9769fb22fe2cef2dc00420111fd4ecf5b19e5c0d
popd


pushd "$(brew --repo homebrew/core)"
git fetch --unshallow
git checkout c7e37d57f0655d422f9a6eb2d225836bca3d7cfa
popd

###################################################################################################################


print_this "Installing Ensembl base libraries"


###############################################################

#Crossmap installtion is failing with bottled Python@2
#Reason:     Bottled python@2 is coming with CC configuration variable with value as 'cc -pthread' rather than 'gcc-5 -pthread'. Python decides on runtime_library_dir_option based on this configuration value. In this case, it is -R for 'cc -pthread'.
#            But, Linuxbrew uses gcc and this gcc doesnt understand -R option while installing crossmap.
#See:        https://github.com/python/cpython/blob/bc6f74a520112d25ef40324e3de4e8187ff2835d/Lib/distutils/unixccompiler.py#L213-L244
#Workaround: Build Python@2 from source first so that it is installed with right configuration values(In our case, CC value as 'gcc-5 -pthread' rather than 'cc -pthread').

if [ ! -z "$IS_A_DOCKER_INSTALL" ]; then brew install python@2 --build-from-source; fi


##############################################################


time brew install ensembl/cask/web-base



print_this "Installing Ensembl base libraries for cpanm"

time brew install ensembl/cask/web-libsforcpanm


# This is a hack to save build time while installing additional libs in ensembl-web-02 dockerfile.
if [ ! -z "$IS_A_DOCKER_INSTALL" ]; then
  time brew install ensembl/external/emboss
fi


# Create a file as a check for installting additional libs from other scripts.
# Should we create an environment variable instead of this?
touch $ENSEMBL_LINUXBREW_DIR/.base_libs_installed
