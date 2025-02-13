script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
echo $script
echo $script_path
exit

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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>  Unzipping file contents  <<<<<<<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>>>  Installing NPM dependenceis  <<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>  copying service file  <<<<<<<<<<<<<\e[0m"
cp $script_path/cart.service /etc/systemd/system/cart.service

cd
echo -e "\e[36m>>>>>>>>>>>  Enabling catalogue service  <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart




