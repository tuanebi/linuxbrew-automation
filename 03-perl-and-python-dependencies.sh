#!/bin/bash


##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}



function install_perl_modules {

   print_this "Installing Perl modules"

   # Download cpanfile containing all the Ensembl Perl module dependencies
   curl -s https://raw.githubusercontent.com/Ensembl/cpanfiles/master/web/cpanfile > cpanfile
   
   # Remove Bio::DB::BigFile entry from cpanfile so that we could install it later after applying Ensembl Kent patches to it
   sed -i '/Bio::DB::BigFile/d' cpanfile 

   # Install Ensembl Perl module dependencies
   time cpanm --installdeps --with-recommends --notest --cpanfile cpanfile .


   print_this "Patching Bio-BigFile with Ensembl Kent patches"

   # Patch Bio-BigFile in line with Kent patches
   curl https://cpan.metacpan.org/authors/id/L/LD/LDS/Bio-BigFile-1.07.tar.gz --output Bio-BigFile-1.07.tar.gz
   tar xvzf Bio-BigFile-1.07.tar.gz
   pushd Bio-BigFile-1.07/
   curl -s https://raw.githubusercontent.com/Ensembl/homebrew-web/master/patches/kent/perl.patch > perl.patch
   patch -p2 < perl.patch
   perl Build.PL
   ./Build
   ./Build test
   ./Build install
   popd

   cpanm HTML::Formatter

   print_this "Installed Perl modules"

}


function install_python_packages {

   print_this "Installing Python packages"

   #Install all the Python packages
   curl -s https://raw.githubusercontent.com/Ensembl/python-requirements/master/web/requirements.txt > requirements.txt
   time pip install -r requirements.txt

   print_this "Installed Python packages"

}

##### Functions end



ENSEMBL_PERL_MODULES="https://raw.githubusercontent.com/Ensembl/cpanfiles/master/web/cpanfile"
ENSEMBL_PYTHON_REQUIREMENTS="https://raw.githubusercontent.com/Ensembl/python-requirements/master/web/requirements.txt"


# Check if 01-base.sh and 02-gui-bioinfo-and-internal.sh scripts are run successfully
if [[ ! -f "$ENSEMBL_LINUXBREW_DIR/.base_libs_installed" || ! -f "$ENSEMBL_LINUXBREW_DIR/.additional_libs_installed" ]]; then
    print_this "Looks like there was a problem either installting base libraries or other additional gui/bioinfo/internal libraries. Install them before running this script. Aborting!"
    return
fi


#if [[ -z $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR || ! -d $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR ]]; then
#   printf "\n%s\n" "****** ENSEMBL_SOFTWARE_DEPENDENCIES_DIR is either not set or $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR directory is empty ******"
#   return
#elif [[ -z $KENT_SRC || ! -d $KENT_SRC  ]]; then
#   printf "\n%s\n" "****** KENT_SRC is either not set or KENT_SRC directory is empty ******"
#   return
#elif [[ -z $HTSLIB_DIR || ! -d $HTSLIB_DIR ]]; then
#   printf "\n%s\n" "****** HTSLIB_DIR is either not set or HTSLIB_DIR directory is empty ******"
#   return
#fi



printf "\n%s\n%s\n" $ENSEMBL_PERL_MODULES $ENSEMBL_PYTHON_REQUIREMENTS

if [ -z "$IS_A_DOCKER_INSTALL" ]; then

    read -p "Perl modules and Python packages from the above files will be installed into $ENSEMBL_LINUXBREW_DIR. Continue?: "  -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       print_this "Aborting installation"
       return
    fi
fi

[ -d "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/tmp" ] || mkdir $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/tmp

pushd $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/tmp

install_perl_modules
install_python_packages

popd



# Create a file as a check for installing Perl modules and Python packages.
# Should we create an environment variable instead of this?
touch $ENSEMBL_LINUXBREW_DIR/.perl_and_python_dependencies_installed
