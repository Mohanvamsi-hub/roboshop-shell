script_path=$(dirname $0)
source $script_path/common.sh

echo -e "\e[36m>>>>>>>>>>>  Installing nginx  <<<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[36m>>>>>>>>>>>  Copying conf file  <<<<<<<<<<<<<\e[0m"
cp roboshop.conf  /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>  Download ZIP file  <<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>>  unzip file  <<<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>  Enabling service  <<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx

