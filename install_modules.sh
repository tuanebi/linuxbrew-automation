#!/bin/bash



ENSEMBL_PERL_MODULES="https://raw.githubusercontent.com/Ensembl/cpanfiles/master/web/cpanfile"
ENSEMBL_PYTHON_REQUIREMENTS="https://raw.githubusercontent.com/Ensembl/python-requirements/master/web/requirements.txt"



if [[ -z $INSTALLATION_PATH || ! -d $INSTALLATION_PATH ]]; then
   printf "\n%s\n" "****** INSTALLATION_PATH is either not set or $INSTALLATION_PATH directory is empty ******"
   return
elif [[ -z $KENT_SRC || ! -d $KENT_SRC  ]]; then
   printf "\n%s\n" "****** KENT_SRC is either not set or KENT_SRC directory is empty ******"
   return
elif [[ -z $HTSLIB_DIR || ! -d $HTSLIB_DIR ]]; then
   printf "\n%s\n" "****** HTSLIB_DIR is either not set or HTSLIB_DIR directory is empty ******"
   return
fi



printf "\n%s\n%s\n" $ENSEMBL_PERL_MODULES $ENSEMBL_PYTHON_REQUIREMENTS

read -p "Perl modules and Python packages from the above files will be installed into $INSTALLATION_PATH build. Continue?: "  -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then



   [ -d "$INSTALLATION_PATH/tmp" ] || mkdir $INSTALLATION_PATH/tmp
   
   printf "\n"


   pushd $INSTALLATION_PATH/tmp


   printf "\n%s\n" "****** Installing Perl modules... ******"

   #Install all the perl dependencies
   curl -s https://raw.githubusercontent.com/Ensembl/cpanfiles/master/web/cpanfile > cpanfile
   cpanm --installdeps --with-recommends --notest --cpanfile cpanfile .

   printf "\n%s\n" "****** Installed Perl modules... ******"


   printf "\n%s\n" "****** Installing Python packages... ******"

   #Install all the Python packages
   curl -s https://raw.githubusercontent.com/Ensembl/python-requirements/master/web/requirements.txt > requirements.txt
   pip install -r requirements.txt

   printf "\n%s\n" "****** Installed Python packages... ******"


   popd

else

   printf "\n%s\n" "****** Aborting modules installation ******"

fi





