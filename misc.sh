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







#Following symlinks makes configuration easy as we can avoid hardcoding paths in Sitedefs.
mkdir -p $SHARED_PATH
mkdir -p $SHARED_PATH/apache
mkdir -p $SHARED_PATH/progressiveCactusFake/submodules/hal/chain
mkdir -p $SHARED_PATH/progressiveCactusFake/submodules/hal/maf


ln -s $INSTALLATION_PATH/linuxbrew/opt/httpd22/libexec $SHARED_PATH/apache/modules
ln -s $INSTALLATION_PATH/linuxbrew/opt/httpd22/bin/httpd $SHARED_PATH/apache/httpd


ln -s $INSTALLATION_PATH/linuxbrew/opt/hdf5@* $SHARED_PATH/progressiveCactusFake/submodules/hdf5
ln -s $INSTALLATION_PATH/linuxbrew/opt/sonlib $SHARED_PATH/progressiveCactusFake/submodules/sonLib
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/lib
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/chain/inc
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARED_PATH/progressiveCactusFake/submodules/hal/maf/inc



ln -s $INSTALLATION_PATH/linuxbrew/opt/emboss $SHARED_PATH/emboss
ln -s $INSTALLATION_PATH/linuxbrew/opt/genewise $SHARED_PATH/genewise
ln -s $INSTALLATION_PATH/linuxbrew/opt/jdk@8/bin/java $SHARED_PATH/java
ln -s $INSTALLATION_PATH/linuxbrew/opt/r2r/bin/r2r $SHARED_PATH/r2r
ln -s $INSTALLATION_PATH/linuxbrew/opt/perl/lib/perl5/site_perl/*/ $SHARED_PATH/bioperl
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/include $SHARED_PATH/htslib
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/gfClient $SHARED_PATH/gfClient
ln -s $INSTALLATION_PATH/linuxbrew/opt/blast/bin $SHARED_PATH/ncbi-blast
ln -s $INSTALLATION_PATH/linuxbrew/opt/repeatmasker/bin/RepeatMasker $SHARED_PATH/RepeatMasker
ln -s $INSTALLATION_PATH/linuxbrew/opt/crossmap/bin/CrossMap.py $SHARED_PATH/CrossMap.py
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/wigToBigWig $SHARED_PATH/wigToBigWig
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/bigWigToWig $SHARED_PATH/bigWigToWig
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/bin/bgzip $SHARED_PATH/bgzip
ln -s $INSTALLATION_PATH/linuxbrew/opt/samtools/bin/samtools $SHARED_PATH/samtools
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/bin/tabix $SHARED_PATH/tabix

ln -s $INSTALLATION_PATH/1000G-tools/vcftools/lib/perl5/site_perl/ $SHARED_PATH/vcftools_perl_lib


