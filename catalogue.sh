echo -e "\e[36m>>>>>>>Disabling Nodejs<<<<<<\e[0m"
dnf module disable nodejs -y
echo -e "\e[36m>>>>>>>Enabling latest version Nodejs<<<<<<\e[0m"
dnf module enable nodejs:18 -y
echo -e "\e[36m>>>>>>>Installing Nodejs<<<<<<\e[0m"
dnf install nodejs -y
useradd roboshop
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>Downloading the ZIP file<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>Unzipping content<<<<<<\e[0m"
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>Installing NPM<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>Copying service file<<<<<<\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>starting the service<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[36m>>>>>>>Copying repo file<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>Install mongo client<<<<<<\e[0m"
dnf install mongodb-org-shell -y
mongo --host mongodb-dev.kmvdevops.shop </app/schema/catalogue.js