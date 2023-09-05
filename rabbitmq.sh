source common.sh

echo -e "${color} Configure YUM Repos from the script provided by vendor. ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.lo
stat_check $?

echo -e "${color} Configure YUM Repos for RabbitMQ. ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.lo
stat_check $?

echo -e "${color} Install RabbitMQ ${nocolor}"
yum install rabbitmq-server -y &>>/tmp/roboshop.lo
stat_check $?

echo -e "${color} Start RabbitMQ Service${nocolor}"
systemctl enable rabbitmq-server &>>/tmp/roboshop.lo
systemctl restart rabbitmq-server &>>/tmp/roboshop.lo
stat_check $?

echo -e "${color} RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence, we need to create one user for the application. ${nocolor}"
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.lo
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.lo
stat_check $?