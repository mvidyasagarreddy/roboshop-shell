echo -e "\e[33mInstalling Maven \e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[33mAdding Roboshop user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating App Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33mDownloading App contents \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting App files \e[0m"
cd /app
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33mClean Package \e[0m"
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33mCopying the Shipping service file m \e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Mysql \e[0m"
yum install mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema \e[0m"
mysql -h mysql-dev.roboshopai.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[33m Enable Shipping Service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
systemctl restart shipping &>>/tmp/roboshop.log