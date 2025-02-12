source common.sh

echo -e "\e[36m>>>>>>>>>>>  Disabling old version and enabling new  <<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>>>>  Installing Nodejs  <<<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>>>  Adding roboshop user  <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>  Adding roboshop user  <<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>  Downloading zip file  <<<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Unzipping file contents  <<<<<<<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>>>>  Installing NPM dependenceis  <<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>  copying service file  <<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

cd
echo -e "\e[36m>>>>>>>>>>>  Enabling catalogue service  <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>>>>  Copying mongo repo file  <<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>  Installing mongo client  <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>  Loading the schema  <<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.kmvdevops.shop </app/schema/user.js


