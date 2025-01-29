echo -e "\e[36m>>>>>>>>>>>Installing package for redis<<<<<<<<<<<\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[36m>>>>>>>>>>>Enabling Redis version<<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y
echo -e "\e[36m>>>>>>>>>>>Installing redis<<<<<<<<<<<\e[0m"
dnf install redis -y
echo -e "\e[36m>>>>>>>>>>>Starting redis service<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis