script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

echo -e "\e[36m>>>>>>>>>>>  Installing GoLang  <<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[36m>>>>>>>>>>>  Add roboshop user  <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>  Creating app directory  <<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>  Downloading app content  <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Extract app content  <<<<<<<<<<<<<\e[0m"
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>  Download dependencies and build  <<<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>>>>  Copying service file  <<<<<<<<<<<<<\e[0m"
cp $script_path/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>>>>  Restart dispatch service  <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch







