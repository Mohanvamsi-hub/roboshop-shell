script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

print_heading "Copying repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
function_stat_check $?

print_heading "Installing mongodb"
dnf install mongodb-org -y &>>$log_file
function_stat_check $?

print_heading "Updating port listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
function_stat_check $?

print_heading "Enabling mongo service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
function_stat_check $?







