echo -e "\[33mInstalling Nginx\e[0m"
yum install nginx -y

echo -e "\[33mRemoving old App content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\[33mDownloading Frontend Content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\[33mExtract Frontend Content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#vim /etc/nginx/default.d/roboshop.conf


echo -e "\[33mStarting Nginx Server\e[0m"
systemctl enable nginx
systemctl restart nginx
