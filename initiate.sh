#!/bin/bash

#echo $0;echo $1;echo $#;echo $@;echo $er;echo $?;if [ $? -eq 0 ];then echo "All OK"; else echo "something's wrong";fi; echo $$;


#set -o xtrace

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

printf "\n%s\n" "****** Continuing... ******"


#Set all the required env variables
source ./set_env.sh




#Install dependencies
./install_formulas.sh 




