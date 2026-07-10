#!/bin/bash

source ./common.sh

app_name=rabbitmq
check_root

cp $SCRIPT_DIR/rabbitmq.service /etc/yum.repos.d/rabbitmq.repo &>>LOGS_FILE
VALIDATE $? "create systemctl rabbitmq..."

dnf install rabbitmq-server -y &>>LOGS_FILE
VALIDATE $? "installing rabbitmq..."

systemctl enable rabbitmq-server &>>LOGS_FILE
systemctl start rabbitmq-server &>>LOGS_FILE
VALIDATE $? "Enable And Start rabbitMq"

rabbitmqctl add_user roboshop roboshop123 &>>LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOGS_FILE
VALIDATE $? "Created user and given permissions"

print_total_time