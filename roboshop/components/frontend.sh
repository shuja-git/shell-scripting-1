#!/bin/bash

# source is nothing but import , like export command
source components/common.sh

yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx Installation"

curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
STAT_CHECK $? "Download frontend"

rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Remove old HTML Pages"

cd /tmp && unzip -o /tmp/frontend.zip &>>${LOG_FILE}
STAT_CHECK $? "Extracting Frontend Content"

cd  /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "Copying Frontend Content"

cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Update Nginx Config File"

systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart Nginx"
