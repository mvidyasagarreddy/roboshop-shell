color="\e[35m"
nocolor=" ${no_color}"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup(){
  echo -e "${color} Add Application User  ${nocolor}"
  useradd roboshop &>>${log_file}

  echo -e "${color} Creating App Directory  ${no_color}"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path}

  echo -e "${color} Download Application content  ${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  cd ${app_path}

  echo -e "${color} Extract the application content  ${nocolor}"
  cd ${app_path}
  unzip /tmp/${component}.zip &>>${log_file}
}

systemd_setup(){
  echo -e "${color} Setup systemd service ${nocolor}"
  cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service

  echo -e "${color} Start ${component} service  ${nocolor}"
  systemctl daemon-reload &>>${log_file}
  systemctl enable ${component} &>>${log_file}
  systemctl restart ${component} &>>${log_file}
}

nodejs(){
  echo -e "${color} Configuring NodeJs Repositories ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

  echo -e "${color} Installing NodeJs  ${nocolor}"
  yum install nodejs -y &>>${log_file}

  app_presetup

  echo -e "${color} Install nodejs Dependencies  ${nocolor}"
  npm install &>>${log_file}

  systemd_setup
}

mongodb(){
  echo -e "${color} Copy mongodb repo file  ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  echo -e "${color} Install mongodb client  ${nocolor}"
  yum install mongodb-org-shell -y &>>${log_file}

  echo -e "${color} Load Schema  ${nocolor}"
  mongo --host mongodb-dev.roboshopai.online <${app_path}/schema/${component}.js &>>${log_file}
}
mysql_schema_setup(){
  echo -e "${color} Installing Mysql  ${no_color}"
  yum install mysql -y &>>${log_file}

  echo -e "${color} Load Schema ${nocolor}"
  mysql -h mysql-dev.devopsb73.store -uroot -p${mysql_root_password} </app/schema/${component}.sql   &>>$log_file
}
maven(){
  echo -e "${color} Installing Maven  ${no_color}"
  yum install maven -y &>>${log_file}

  app_presetup

  echo -e "${color} Clean Package  ${no_color}"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}


  mysql_schema_setup

  systemd_setup
}