script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
rabbitmq_adduser_password=$1

echo -e "\e[36m>>>>>>>>>>>  Configuring repo for erlang  <<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>  Configuring repo for rabbitmq  <<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>  Installing rabbitmq  <<<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>>  starting the service  <<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>>>  Adding user and setting permission  <<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_adduser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"





