source common.sh

echo -e "\e[36m>>>>>>>>>>>  Installing maven  <<<<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>>>>>>>  Add roboshop user and app directory  <<<<<<<<<<<<<\e[0m"
useradd ${app_user}
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>  Download application code  <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Unzipping shipping zip file  <<<<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>>  Download dependencies  <<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>>  Copying shipping service file  <<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>  Installing MySQL  <<<<<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[36m>>>>>>>>>>>  Load schema  <<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.kmvdevops.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>>  Shipping service start  <<<<<<<<<<<<<\e[0m"
systemctl enable shipping
systemctl restart shipping

