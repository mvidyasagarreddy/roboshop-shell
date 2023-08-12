source common.sh
component=cart


echo -e "${color}  Configuring NodeJS Repos ${no_color}  "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log_file}

echo -e "${color}  Install NodeJS ${no_color}  "
yum install nodejs -y  &>>${log_file}

echo -e "${color}  Add Application User ${no_color}  "
useradd roboshop  &>>${log_file}

echo -e "${color}  Create Application Directory  ${no_color}  "
rm -rf ${app_path}  &>>${log_file}
mkdir ${app_path}

echo -e "${color}  Download Application Content ${no_color}  "
curl -o /tmp/${component}  .zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}
cd ${app_path}

echo -e "${color}  Extract Application Content ${no_color}  "
unzip /tmp/${component}.zip  &>>${log_file}
cd ${app_path}

echo -e "${color}  Install NodeJS Dependencies ${no_color}  "
npm install  &>>${log_file}

echo -e "${color}  Setup SystemD Service   ${no_color}  "
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}

echo -e "${color}  Start ${component} Service  ${no_color}  "
systemctl daemon-reload  &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl restart ${component}  &>>${log_file}