
component=&component

echo -e "\e[33mConfiguring NodeJs Repositories\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstalling NodeJs \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdding Roboshop user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreate the application directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33mDownload Application content \e[0m"
curl -o /tmp/&component.zip https://roboshop-artifacts.s3.amazonaws.com/&component.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33mExtract the application content \e[0m"
unzip /tmp/&component.zip &>>/tmp/roboshop.log

echo -e "\e[33mInstall nodejs Dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup systemd service\e[0m"
cp /home/centos/roboshop-shell/&component.service /etc/systemd/system/&component.service

echo -e "\e[33mStart Catalogue service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable &component &>>/tmp/roboshop.log
systemctl restart &component &>>/tmp/roboshop.log

echo -e "\e[33mCopy mongodb repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstall mongodb client \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema \e[0m"
mongo --host mongodb-dev.roboshopai.online </app/schema/&component.js &>>/tmp/roboshop.log