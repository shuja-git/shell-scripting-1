#!/bin/bash

source components/common.sh

MAX_LENGTH=$(cat ${0}  | grep -v -w cat | grep STAT_CHECK | awk -F '"' '{print $2}'  | awk '{ print length }'  | sort  | tail -1)

if [ $MAX_LENGTH -lt 24 ];then
  MAX_LENGTH=24
fi

yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install NodeJS"

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd roboshop   &>>${LOG_FILE}
  STAT_CHECK $? "Add Application User"
fi


DOWNLOAD catalogue

rm -rf /home/roboshop/catalogue && mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue &>>${LOG_FILE}
STAT_CHECK $? "Copy Catalogue Content"

cd /home/roboshop/catalogue && npm install
STAT_CHECK $? "Install NodeJS dependencies"

#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.
#
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## systemctl daemon-reload
## systemctl start catalogue
## systemctl enable catalogue