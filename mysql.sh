script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

echo -e "\e[36m>>>>>>>>>>>  Disabling old version of MySQL  <<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>  Copying repo SQL file  <<<<<<<<<<<<<\e[0m"
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>>  Installing mysql  <<<<<<<<<<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>  starting mysql service  <<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>>  setting password  <<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1












