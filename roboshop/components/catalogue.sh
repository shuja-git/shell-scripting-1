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

cd /home/roboshop/catalogue && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "Install NodeJS dependencies"

chown roboshop:roboshop -R /home/roboshop

sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service  &>>${LOG_FILE}
STAT_CHECK $? "Update SystemD Config file"

systemctl daemon-reload &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
STAT_CHECK $? "Start Catalogue Service"
