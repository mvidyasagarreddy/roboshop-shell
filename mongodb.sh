echo -e "\e[33mCopying the repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MongoDB server\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log &>>/tmp/roboshop.log

echo -e "\Update MongoDB listen address[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[33m Start MongoDB Service\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log &>>/tmp/roboshop.log