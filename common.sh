#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER 

echo -e "$(date "+%Y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
       echo -e "$R please run the script root level $N" |  tee -a $LOGS_FILE
       exit 1
    fi
}
mkdir -p $LOGS_FOLDER 

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2....$R FAILUR $N" | tee -a $LOGS_FILE
        exit 1
    else 
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2...$G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

print_total_time(){
   END_TIME=$(date +%s)
   TOTAL_TIME=$(( $END_TIME - $START_TIME ))
   echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME in seconds $N" | tee -a $LOGS_FILE
}