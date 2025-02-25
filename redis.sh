script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh


print_heading "Installing redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.9.rpm -y &>>$log_file
function_stat_check $?

print_heading "Enabling redis 6.2"
dnf module enable redis:remi-6.2 -y &>>$log_file
function_stat_check $?

print_heading "Installing redis"
dnf install redis -y &>>$log_file
function_stat_check $?

print_heading "change port address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
function_stat_check $?

print_heading "Enabling redis service"
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
function_stat_check $?







