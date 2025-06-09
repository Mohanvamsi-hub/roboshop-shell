script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
rabbitmq_adduser_password=$1

if [ -z "$rabbitmq_adduser_password" ]
then
  echo Password not provided
  exit 1
fi


print_heading "Configuring repo for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
function_stat_check $?

print_heading "Configuring repo for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
function_stat_check $?

print_heading "Installing rabbitmq"
dnf install rabbitmq-server -y &>>$log_file
function_stat_check $?

print_heading "Starting Rabbitmq service"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
function_stat_check $?

print_heading "Adding user and setting permission"
rabbitmqctl add_user roboshop ${rabbitmq_adduser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
function_stat_check $?






