script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

print_heading "Installing nginx"
dnf install nginx -y &>>$log_file
function_stat_check $?

print_heading "Copying configuration file"
cp roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>$log_file
function_stat_check $?

print_heading "Removing the old content if exist"
rm -rf /usr/share/nginx/html/* &>>$log_file
function_stat_check $?

print_heading "Download ZIP file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
function_stat_check $?

cd /usr/share/nginx/html &>>$log_file


print_heading "Unzipping zip file"
unzip /tmp/frontend.zip &>>$log_file
function_stat_check $?

print_heading "Enabling service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
function_stat_check $?



