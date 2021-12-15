#!/bin/bash

# source is nothing but import , like export command
source components/common.sh

yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx Installation"

DOWNLOAD frontend

rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Remove old HTML Pages"

cd  /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "Copying Frontend Content"

cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Copy Nginx Config File"

for component in catalogue cart user shipping payment ; do
  sed -i -e "/${component}/ s/localhost/${component}.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
STAT_CHECK $? "Update Nginx Config File"

systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart Nginx"
