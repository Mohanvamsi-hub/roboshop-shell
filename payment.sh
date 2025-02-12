script_path=$(dirname $0)
source $script_path/common.sh

echo -e "\e[36m>>>>>>>>>>>  Installing python  <<<<<<<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>  Add roboshop user  <<<<<<<<<<<<<\e[0m"
useradd ${app_user}
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>  Download the application code to created app directory  <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Uzipping app content  <<<<<<<<<<<<<\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>>  Installing python dependencies  <<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>  Copying service file  <<<<<<<<<<<<<\e[0m"
cd
cp $script_path/payment.service /etc/systemd/system/payment.service
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>  starting the payment service  <<<<<<<<<<<<<\e[0m"
systemctl enable payment
systemctl restart payment
