#!/bin/bash

source ./common.sh

app_name=shipping

check_root
app_setup
java_setup
systemd_setup


dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "install mysql...."

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql


app_restart
print_total_time