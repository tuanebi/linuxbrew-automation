#!/bin/bash

##### Functions start

function print_this {

   printf '%.0s*' {1..125}; echo
   printf "%s" "$@"; echo
   printf '%.0s*' {1..125}; echo

}


##### Functions end





# Check if 01-base.sh and 02-gui-bioinfo-and-internal.sh scripts are run successfully
if [[ ! -f "$ENSEMBL_LINUXBREW_DIR/.base_libs_installed" || ! -f "$ENSEMBL_LINUXBREW_DIR/.additional_libs_installed" || ! -f "$ENSEMBL_LINUXBREW_DIR/.perl_and_python_dependencies_installed"  ]]; then
    print_this "This scripts needs base, additional, perl and python dependencies installed. Install them before running this script. Aborting!"
    return
fi



if [ -z "$IS_A_DOCKER_INSTALL" ]; then

    read -p "Symlinks will be created into $SHARED_PATH directory pointing to $ENSEMBL_LINUXBREW_DIR directory. Continue?: "  -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       print_this "Aborting!"
       return
    fi
fi



#if [[ -z $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR || ! -d $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR ]]; then
#  printf "\n%s\n" "****** ENSEMBL_SOFTWARE_DEPENDENCIES_DIR is either not set or $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR directory is empty ******"
#  return
#fi


print_this "Setting up fonts"

if [[ -d '/usr/share/fonts/msttcore/' ]]; then
    ln -s /usr/share/fonts/msttcore ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/fonts
    printf "\n%s\n%s\n" "***** Microsoft True Type fonts found *****" "****** ln -s /usr/share/fonts/msttcore/ ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/fonts ******"
elif [[ -d '/usr/local/share/fonts/msttcore/' ]]; then
    ln -s /usr/local/share/fonts/msttcore/ ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/fonts
    printf "\n%s\n%s\n" "***** Microsoft True Type fonts found *****" "****** ln -s /usr/local/share/fonts/msttcore/ ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/fonts ******"
else 
    printf "\n%s\n" "****** Looks like Microsoft True Type fonts are not installed on your machine. Please install them before proceeding ******"
    return
fi



print_this "Installing hubcheck and FileChameleon"

#At the moment, utils hosts hubcheck and FileChameleon
[ -d "$ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/utils" ] || mkdir $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/utils
 
pushd $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/utils 
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/hubCheck
git clone https://github.com/Ensembl/format-transcriber.git
popd
ln -s ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/utils/format-transcriber/ ${ENSEMBL_SOFTWARE_DEPENDENCIES_DIR}/FileChameleon







#Following symlinks makes configuration easy as we can avoid hardcoding paths in Sitedefs.
mkdir -p $SHARED_PATH
mkdir -p $SHARED_PATH/apache
mkdir -p $SHARED_PATH/progressiveCactusFake/submodules/hal/chain
mkdir -p $SHARED_PATH/progressiveCactusFake/submodules/hal/maf


ln -s $ENSEMBL_LINUXBREW_DIR/opt/httpd22/libexec $SHARED_PATH/apache/modules
ln -s $ENSEMBL_LINUXBREW_DIR/opt/httpd22/bin/httpd $SHARED_PATH/apache/httpd


ln -s $ENSEMBL_LINUXBREW_DIR/opt/hdf5@* $SHARED_PATH/progressiveCactusFake/submodules/hdf5
ln -s $ENSEMBL_LINUXBREW_DIR/opt/sonlib $SHARED_PATH/progressiveCactusFake/submodules/sonLib
ln -s $ENSEMBL_LINUXBREW_DIR/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/lib
ln -s $ENSEMBL_LINUXBREW_DIR/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/chain/inc
ln -s $ENSEMBL_LINUXBREW_DIR/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/maf/inc



ln -s $ENSEMBL_LINUXBREW_DIR/opt/emboss $SHARED_PATH/emboss
ln -s $ENSEMBL_LINUXBREW_DIR/opt/genewise $SHARED_PATH/genewise
ln -s $ENSEMBL_LINUXBREW_DIR/opt/jdk@8/bin/java $SHARED_PATH/java
ln -s $ENSEMBL_LINUXBREW_DIR/opt/r2r/bin/r2r $SHARED_PATH/r2r
ln -s $ENSEMBL_LINUXBREW_DIR/opt/perl/lib/perl5/site_perl/*/ $SHARED_PATH/bioperl
ln -s $ENSEMBL_LINUXBREW_DIR/opt/htslib/include $SHARED_PATH/htslib
ln -s $ENSEMBL_LINUXBREW_DIR/opt/kent/bin/gfClient $SHARED_PATH/gfClient
ln -s $ENSEMBL_LINUXBREW_DIR/opt/blast/bin $SHARED_PATH/ncbi-blast
ln -s $ENSEMBL_LINUXBREW_DIR/opt/repeatmasker/bin/RepeatMasker $SHARED_PATH/RepeatMasker
ln -s $ENSEMBL_LINUXBREW_DIR/opt/crossmap/bin/CrossMap.py $SHARED_PATH/CrossMap.py
ln -s $ENSEMBL_LINUXBREW_DIR/opt/kent/bin/wigToBigWig $SHARED_PATH/wigToBigWig
ln -s $ENSEMBL_LINUXBREW_DIR/opt/kent/bin/bigWigToWig $SHARED_PATH/bigWigToWig
ln -s $ENSEMBL_LINUXBREW_DIR/opt/htslib/bin/bgzip $SHARED_PATH/bgzip
ln -s $ENSEMBL_LINUXBREW_DIR/opt/samtools/bin/samtools $SHARED_PATH/samtools
ln -s $ENSEMBL_LINUXBREW_DIR/opt/htslib/bin/tabix $SHARED_PATH/tabix

ln -s $ENSEMBL_SOFTWARE_DEPENDENCIES_DIR/1000G-tools/vcftools/lib/perl5/site_perl/ $SHARED_PATH/vcftools_perl_lib


