#!/bin/bash

source ./common.sh
app_name=mysql
check_root

dnf install mysql-server -y &>>LOGS_FILE
systemctl enable mysqld &>>LOGS_FILE
systemctl start mysqld  &>>LOGS_FILE
VALIDATE $? "Install, enable and start mysql..."

mysql_secure_installation --set-root-pass RoboShop@1 &>>LOGS_FILE
VALIDATE $? "Setup root password"

print_total_time 