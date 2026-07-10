#!/bin/bash

app_name=shipping
MYSQL_HOST="mysql.solohunting.online"
check_root


dnf install maven -y &>>$LOGS_FILE
VALIDATE $? "install maven...."

app_setup
systemd_setup


dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "install mysql...."

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql


app_restart