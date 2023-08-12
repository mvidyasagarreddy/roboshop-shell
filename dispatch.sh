
echo -e "\e[33mInstall GoLang \e[0m"
yum install golang -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mSetup an app directory. \e[0m"
rmdir /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33mDownload the application code to created app directory. \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[33mDownload the dependencies & build the software. \e[0m"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD Payment Service \e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

echo -e "\e[33mLoad and restart the service.\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log
