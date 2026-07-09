#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_DIR=$PWD

START_TIME=$(date +%s)

MONGODB_HOST="mongo.solohunting.online"


mkdir -p $LOGS_FOLDER 

echo -e "$(date "+%Y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
       echo -e "$R please run the script root level $N" |  tee -a $LOGS_FILE
       exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2....$R FAILUR $N" | tee -a $LOGS_FILE
        exit 1
    else 
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2...$G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

#nodejs configure
nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "diseable Nodejs ...."

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "enable nodejs-20 ....."

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "installing Nodejs ...." 
    
    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing Dependencies..."
}


#App coffigure
 app_setup(){
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Add system user..."
    else
        echo -e "Roboshop user already exit...$Y SKIPPING $N" &>>$LOGS_FILE
    fi

    mkdir -p /app &>>$LOGS_FILE
    VALIDATE $? "create app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Download $app_name code..."

    cd /app &>>LOGS_FILE
    VALIDATE $? "Moving to app Directory..." 

    rm -rf /app/* &>>$LOGS_FILE
    VALIDATE $? "Removeing Existing code..."

    unzip /tmp/$app_name.zip &>>LOGS_FILE
    VALIDATE $? "unzip $app_name the code..."
 }
#systemd_confic
systemd_setup(){

    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    VALIDATE $? "Created systemctl service"

    systemctl daemon-reload
    systemctl enable $app_name &>>$LOGS_FILE
    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "Start AND Enabling $app_name.."
}

#App restart
app_restart(){
    systemctl restart $app_name &>>$LOGS_FILE
    VALIDATE $? "Restart $app_name"
}

#Total_time
 print_total_time(){
   END_TIME=$(date +%s)
   TOTAL_TIME=$(( $END_TIME - $START_TIME ))
   echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME in seconds $N" | tee -a $LOGS_FILE
}