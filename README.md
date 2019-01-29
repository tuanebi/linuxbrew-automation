# linuxbrew-automation

This repo hosts scripts to build all the required software to run an Ensembl site.

These scripts were tested and works fine on RHEL 7 and CentOS 7 machines. Future updates will be made to use these scripts on RHEL 6 machine.

These script installs libs using Linuxbrew. Linuxbrew is a clone of homebrew, the MacOS package manager, for Linux, which allows users to install software to their home directory or any custom location. More on Linuxbrew [here](http://linuxbrew.sh/).

Each script does some checks and installs software libs from casks. A cask is a list of libs logically grouped together. 

Ensembl uses these scripts to install software libs on its RHEL 7 machines and on [Docker images](https://github.com/Ensembl/ensembl-web-docker).

These scripts should be run sequentially in the order of number preceding on each script name. 

Script 01-base-libraries.sh takes one input parameter - location where you wanted to install all the software. If location parameter is not supplied, it installs everything into PWD/<current_date>.

All other scripts doesn't require any input parameters and use environment variables set during enviromment setup when you ran 01-base-libraries.sh script.


