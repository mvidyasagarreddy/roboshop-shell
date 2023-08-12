
component=catalogue
color="\e[36m"
nocolor="\e[0m"

echo -e "${color} Configuring NodeJs Repositories ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "${color} Installing NodeJs  ${nocolor}"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "${color} Adding Roboshop user  ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${color} Create the application directory  ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "${color} Download Application content  ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app

echo -e "${color} Extract the application content  ${nocolor}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log

echo -e "${color} Install nodejs Dependencies  ${nocolor}"
npm install &>>/tmp/roboshop.log

echo -e "${color} Setup systemd service ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service

echo -e "${color} Start $component service  ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl restart $component &>>/tmp/roboshop.log

echo -e "${color} Copy mongodb repo file  ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "${color} Install mongodb client  ${nocolor}"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "${color} Load Schema  ${nocolor}"
mongo --host mongodb-dev.roboshopai.online </app/schema/$component.js &>>/tmp/roboshop.log