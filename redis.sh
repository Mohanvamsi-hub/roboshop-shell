script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

echo -e "\e[36m>>>>>>>>>>>  Installing redis repo  <<<<<<<<<<<<<\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.9.rpm -y

echo -e "\e[36m>>>>>>>>>>>  Enabling redis 6.2  <<<<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[36m>>>>>>>>>>>  Installing redis  <<<<<<<<<<<<<\e[0m"
dnf install redis -y

echo -e "\e[36m>>>>>>>>>>>  change port address  <<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[36m>>>>>>>>>>>  Enabling redis service  <<<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis








