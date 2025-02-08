echo -e "\e[36m>>>>>>>>>>>  Copying repo file  <<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>  Installing mongodb  <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org -y

echo -e "\e[36m>>>>>>>>>>>  Updating port listen address  <<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>>>>  Enabling mongo service  <<<<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod