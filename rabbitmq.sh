
echo -e "\e[33mConfigure YUM Repos from the script provided by vendor. \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.lo

echo -e "\e[33mConfigure YUM Repos for RabbitMQ. \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.lo

echo -e "\e[33mInstall RabbitMQ \e[0m"
yum install rabbitmq-server -y &>>/tmp/roboshop.lo

echo -e "\e[33mRabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence, we need to create one user for the application. \e[0m"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.lo
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.lo


echo -e "\e[33mStart RabbitMQ Service\e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.lo
systemctl restart rabbitmq-server &>>/tmp/roboshop.lo