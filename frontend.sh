#!/bin/bash

source ./common.sh

app_name=frontend
check_root

dnf module list nginx &>>LOGS_FILE
VALIDATE $? "install module list..."

dnf module disable nginx -y &>>LOGS_FILE
dnf module enable nginx:1.24 -y &>>LOGS_FILE
dnf install nginx -y &>>LOGS_FILE
VALIDATE $? "installing nginx.."

systemctl enable nginx &>>LOGS_FILE
systemctl start nginx &>>LOGS_FILE
VALIDATE $? "Enable And Start nginx.."

rm -rf /usr/share/nginx/html/* &>>LOGS_FILE
VALIDATE $? "Remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>LOGS_FILE
cd /usr/share/nginx/html  
unzip /tmp/frontend.zip &>>LOGS_FILE
VALIDATE $? "download the forntend code..."

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>LOGS_FILE
VALIDATE $? "createing systemctl service..."

systemctl restart nginx &>>LOGS_FILE
VALIDATE $? "restart nginx"

print_total_time