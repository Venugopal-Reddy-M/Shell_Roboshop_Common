#!/bin/bash

source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup
print_total_time


# Loading data into mongodb
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGS_FILE
dnf install mongodb-mongosh -y

mongosh --host $MONGODB_HOST </app/db/master-data.js &>>LOGS_FILE
VALIDATE $? "master data loaded..."

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "LOADING PRODUCTS"
else
  echo "PRODUCTS ALREADY LOADED ..."
fi

app_restart
print_total_time