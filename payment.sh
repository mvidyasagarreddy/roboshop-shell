
echo -e "\e[33mInstall Python 3.6 \e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mSetup an app directory. \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33mDownload the application code to created app directory. \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log


echo -e "\e[33mUnzip the code \e[0m"
cd /app
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33mDownload the dependencies.\e[0m"
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD Payment Service \e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log

echo -e "\e[33mLoad and restart the service. \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log