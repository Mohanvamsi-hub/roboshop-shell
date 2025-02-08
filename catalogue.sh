echo -e "\e[36m>>>>>>>>>>>  Disabling old version and enabling new  <<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>>>>  Installing Nodejs  <<<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>>>  Adding roboshop user  <<<<<<<<<<<<<\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[36m>>>>>>>>>>>  Downloading zip file  <<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Unzipping file contents  <<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>  Installing NPM dependenceis  <<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>  copying service file  <<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>>  Enabling catalogue service  <<<<<<<<<<<<<\e[0m"
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>>>  Copying mongo repo file  <<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>  Installing mongo client  <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>  Loading the schema  <<<<<<<<<<<<<\e[0m"
mongo --host catalogue-dev.kmvdevops.shop </app/schema/catalogue.js


