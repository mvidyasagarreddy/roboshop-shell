source common.sh


echo -e "${color} Installing Nginx ${nocolor}"
yum install nginx -y &>>${log_file}
stat_check $?

echo -e "${color} Removing old App content  ${nocolor}"
rm -rf /usr/share/nginx/html/* &>>${log_file}
stat_check $?

echo -e "${color} Downloading Frontend Content  ${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
stat_check $?

echo -e "${color} Extract Frontend Content ${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
stat_check $?


echo -e "${color} Copy the config file ${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
stat_check $?

echo -e "${color} Starting Nginx Server ${nocolor}"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
stat_check $?
