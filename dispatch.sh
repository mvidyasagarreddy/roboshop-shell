source common.sh


echo -e "${color} Install GoLang  ${nocolor}"
yum install golang -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Add application User  ${nocolor}"
id roboshop &>>$log_file
  if [ $? -eq 1 ]; then
    useradd roboshop  &>>$log_file
  fi
stat_check $?

echo -e "${color} Setup an app directory.  ${nocolor}"
rmdir /app &>>/tmp/roboshop.log
mkdir /app
stat_check $?

echo -e "${color} Download the application code to created app directory.  ${nocolor}"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Download the dependencies & build the software.  ${nocolor}"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Setup SystemD Payment Service  ${nocolor}"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Load and restart the service. ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log
stat_check $?
