#!/bin/bash

source ./common.sh

app_name=reddis
check_root

if [ $? -ne 0 ]; then
   dnf module disable redis -y &>>$LOGS_FILE
   VALIDATE $? "Disable redis..."
else 
 echo "disable redis already"
fi

if [ $? -ne 0 ]; then
  dnf module enable redis:7 -y &>>$LOGS_FILE
  VALIDATE $? "Enable redis..."
else
  echo "Enable redis...alredy"
fi  

dnf install redis -y 
VALIDATE $? "Installing redis..." &>>$LOGS_FILE

#mkdir -p $CONFIC_REDIS

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOGS_FILE
VALIDATE $? "Allowing remote..."

systemctl enable redis &>>$LOGS_FILE
systemctl start redis &>>$LOGS_FILE
VALIDATE $? "enable and start.... "

print_total_time 