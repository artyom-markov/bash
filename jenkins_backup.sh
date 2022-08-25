#!/bin/bash
JENKINS_HOME=/var/lib/jenkins/
BACKUP_FOLDER=/home/ubuntu/backup_jenkins/
SOURCE_FOLDER=/home/ubuntu/Backups/prod-jenkins-app-01
date=`date +%H.%M.%S-%m-%d-%Y`
#0) ssh to jenkins host
#1) Select folders to backup
#2) Copy them to separate directory
#3) Tar and gz directory
#4) Scp backup.tar.gz to backup host


#0) ssh to jenkins host

#ssh jenkins_main


#1) Select folders to backup

#read -p 'Type jenkins home directory: ' JENKINS_HOME


#2) Copy them to separate directory
ssh jenkins_main << EOF
sudo su 

mkdir $BACKUP_FOLDER
cp $JENKINS_HOME/*.xml $BACKUP_FOLDER
cp -r $JENKINS_HOME/jobs $BACKUP_FOLDER
cp -r $JENKINS_HOME/plugins $BACKUP_FOLDER
cp -r $JENKINS_HOME/userContent $BACKUP_FOLDER
cp -r $JENKINS_HOME/users $BACKUP_FOLDER
cp -r $JENKINS_HOME/nodes $BACKUP_FOLDER
cp -r $JENKINS_HOME/secrets $BACKUP_FOLDER 

tar -zcf $BACKUP_FOLDER_$date.tar.gz $BACKUP_FOLDER
exit

EOF

#4) Scp backup.tar.gz to backup host

scp jenkins_main:$date.tar.gz $SOURCE_FOLDER

#5) Delete tar.gz from jenkins_main

ssh jenkins_main << EOF

sudo su
rm -f $date.tar.gz 
rm -rf $BACKUP_FOLDER

exit

EOF

#6) Delete backup older than 5 days

find $SOURCE_FOLDER -type d -mtime +5 -exec rm -r {}
