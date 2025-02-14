script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

component_name=user

function_nodejs

echo -e "\e[36m>>>>>>>>>>>  Copying mongo repo file  <<<<<<<<<<<<<\e[0m"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>  Installing mongo client  <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>  Loading the schema  <<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.kmvdevops.shop </app/schema/user.js


