#!/bin/sh

bk_date=$(date "+%Y-%m-%dT%H_%M_%S")
bk_source="/home/ubuntu"
bk_dest="/home/ubuntu/backup"
bk_retention="1"
down_wait="20"
up_wait="40"

Help()
{
   # Display Help
   echo "Bash script to backup docker-compose container."
   echo "Make sure setup your docker-compose to store all configuration"
   echo "and volume data in the same directory."
   echo
   echo "Syntax: docker-compose-backup.sh DCOKER-COMPOSE-FOLDER-NAME [-h|V]"
   echo "options:"
   echo "h     Print this Help."
   echo "V     Print software version and exit."
   echo
}

# Get the options
while getopts ":h:V" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      V) # Display version
         echo "Version: 0.01"
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

# check backup directory
if [ ! -d ${bk_dest} ]; then
        echo "Missing/wrong backup directory!"
        exit;
fi

# keep how many of backup copy
# uncomment below to enable backup housekeeping
#find ${bk_dest} -name "*.tar.gz" -type f -mtime +${bk_retention}
#find ${bk_dest} -name "*.tar.gz" -type f -mtime +${bk_retention} -delete

if [ -z $1 ]; then
        echo "Missing input!\n"
        Help
elif [ -d ${bk_source}/$1 ]; then
        # Stop docker container
        docker-compose -f ${bk_source}/$1/docker-compose.yml down
        # Wait x second for the docker container to properly shutdown
        sleep ${down_wait}
        # Archive docker container and volume data
        cd ${bk_source} && tar -zcvf ${bk_dest}/$1_${bk_date}.tar.gz $1
        # Archive docker container and volume data with file exclude
        #cd ${bk_source} && tar -zcvf ${bk_dest}/$1_${bk_date}.tar.gz --exclude-vcs --exlude="*.md" $1
        # Start up the docker container
        docker-compose -f ${bk_source}/$1/docker-compose.yml up -d
        # Wait x second for the docker container to properly startup
        sleep ${up_wait}
        # Reboot the host. Enable only if you have setup custom iptables rules at startup
        # and set all backup archives owner if run the script via sudo
        #chown ubuntu:ubuntu ${bk_dest}/$1_*
        #/usr/sbin/reboot
        exit;
else
        echo "No such docker-compose directory!\n"
        Help
fi
