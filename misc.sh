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
mkdir -p $SHARE_PATH
mkdir -p $SHARE_PATH/apache
mkdir -p $SHARE_PATH/progressiveCactusFake/submodules/hal/chain
mkdir -p $SHARE_PATH/progressiveCactusFake/submodules/hal/maf


ln -s $INSTALLATION_PATH/linuxbrew/opt/httpd22/libexec $SHARE_PATH/apache/modules
ln -s $INSTALLATION_PATH/linuxbrew/opt/httpd22/bin/httpd $SHARE_PATH/apache/httpd


ln -s $INSTALLATION_PATH/linuxbrew/opt/hdf5@* $SHARE_PATH/progressiveCactusFake/submodules/hdf5
ln -s $INSTALLATION_PATH/linuxbrew/opt/sonlib $SHARE_PATH/progressiveCactusFake/submodules/sonLib
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARE_PATH/progressiveCactusFake/submodules/hal/lib
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARE_PATH/progressiveCactusFake/submodules/hal/chain/inc
ln -s $INSTALLATION_PATH/linuxbrew/opt/hal/lib/ $SHARE_PATH/progressiveCactusFake/submodules/hal/maf/inc



ln -s $INSTALLATION_PATH/linuxbrew/opt/emboss $SHARE_PATH/emboss
ln -s $INSTALLATION_PATH/linuxbrew/opt/genewise $SHARE_PATH/genewise
ln -s $INSTALLATION_PATH/linuxbrew/opt/jdk@8/bin/java $SHARE_PATH/java
ln -s $INSTALLATION_PATH/linuxbrew/opt/r2r/bin/r2r $SHARE_PATH/r2r
ln -s $INSTALLATION_PATH/linuxbrew/opt/perl/lib/perl5/site_perl/*/ $SHARE_PATH/bioperl
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/include $SHARE_PATH/htslib
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/gfClient $SHARE_PATH/gfClient
ln -s $INSTALLATION_PATH/linuxbrew/opt/blast/bin $SHARE_PATH/ncbi-blast
ln -s $INSTALLATION_PATH/linuxbrew/opt/repeatmasker/bin/RepeatMasker $SHARE_PATH/RepeatMasker
ln -s $INSTALLATION_PATH/linuxbrew/opt/crossmap/bin/CrossMap.py $SHARE_PATH/CrossMap.py
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/wigToBigWig $SHARE_PATH/wigToBigWig
ln -s $INSTALLATION_PATH/linuxbrew/opt/kent/bin/bigWigToWig $SHARE_PATH/bigWigToWig
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/bin/bgzip $SHARE_PATH/bgzip
ln -s $INSTALLATION_PATH/linuxbrew/opt/samtools/bin/samtools $SHARE_PATH/samtools
ln -s $INSTALLATION_PATH/linuxbrew/opt/htslib/bin/tabix $SHARE_PATH/tabix

ln -s $INSTALLATION_PATH/1000G-tools/vcftools/lib/perl5/site_perl/ $SHARE_PATH/vcftools_perl_lib


