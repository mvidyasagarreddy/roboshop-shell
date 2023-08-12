color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

nodejs(){
  echo -e "${color} Configuring NodeJs Repositories ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

  echo -e "${color} Installing NodeJs  ${nocolor}"
  yum install nodejs -y &>>${log_file}

  echo -e "${color} Adding Roboshop user  ${nocolor}"
  useradd roboshop &>>${log_file}

  echo -e "${color} Create the application directory  ${nocolor}"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path}

  echo -e "${color} Download Application content  ${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
  cd ${app_path}

  echo -e "${color} Extract the application content  ${nocolor}"
  unzip /tmp/$component.zip &>>${log_file}

  echo -e "${color} Install nodejs Dependencies  ${nocolor}"
  npm install &>>${log_file}

  echo -e "${color} Setup systemd service ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service

  echo -e "${color} Start $component service  ${nocolor}"
  systemctl daemon-reload &>>${log_file}
  systemctl enable $component &>>${log_file}
  systemctl restart $component &>>${log_file}
}

mongodb(){
  echo -e "${color} Copy mongodb repo file  ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  echo -e "${color} Install mongodb client  ${nocolor}"
  yum install mongodb-org-shell -y &>>${log_file}

  echo -e "${color} Load Schema  ${nocolor}"
  mongo --host mongodb-dev.roboshopai.online <${app_path}/schema/$component.js &>>${log_file}
}