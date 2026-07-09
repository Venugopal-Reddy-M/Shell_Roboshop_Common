#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "installing mongoDB"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "enable mongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGS_FILE
VALIDATE $? "Allowing remote"

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "restart" 