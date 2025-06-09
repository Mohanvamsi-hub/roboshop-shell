script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_password=$1

if [ -z "$mysql_password" ]
then
  echo Password not provided
  exit 1
fi


print_heading "Disabling old version of MySQL"
dnf module disable mysql -y &>>$log_file
function_stat_check $?

print_heading "Copying repo SQL file"
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
function_stat_check $?

print_heading "Installing MySQL"
dnf install mysql-community-server -y &>>$log_file
function_stat_check $?

print_heading "starting mysql service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
function_stat_check $?

print_heading "setting password"
mysql_secure_installation --set-root-pass ${mysql_password} &>>$log_file
function_stat_check $?












