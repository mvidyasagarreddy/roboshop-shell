source common.sh

echo -e "${color} Copying the repo file   ${nocolor}"
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Installing MongoDB server ${nocolor}"
yum install mongodb-org -y &>>/tmp/roboshop.log &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Update MongoDB listen address ${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "${color}  Start MongoDB Service  ${nocolor}"
systemctl enable mongod &>>/tmp/roboshop.log &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log &>>/tmp/roboshop.log
stat_check $?