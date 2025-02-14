app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log


print_heading(){
  echo -e "\e[36m>>>>>>>>>>>  $1  <<<<<<<<<<<<<\e[0m"
  echo -e "\e[36m>>>>>>>>>>>  $1  <<<<<<<<<<<<<\e[0m" &>>$log_file
}

function_stat_check() {
    if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo -e "Refer the log file /tmp/roboshop.log for more information"
      exit 1
    fi
}

function_schema() {
  if [ "$schema_setup" == "mongo" ]; then

    print_heading "Copying mongo repo file"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    function_stat_check $?

    print_heading "Installing mongo client"
    dnf install mongodb-org-shell -y &>>$log_file
    function_stat_check $?

    print_heading "Loading the schema"
    mongo --host mongodb-dev.kmvdevops.shop </app/schema/${component_name}.js &>>$log_file
    function_stat_check $?

  fi

  if [ "$schema_setup" == "mysql" ]; then

    print_heading "Installing MySQL"
    dnf install mysql -y &>>$log_file
    function_stat_check $?

    print_heading "Load schema"
    mysql -h mysql-dev.kmvdevops.shop -uroot -p${mysql_password} < /app/schema/${component_name}.sql &>>$log_file
    function_stat_check $?

  fi
}


function_prereq() {
    print_heading "Add application user"
    id ${app_user} &>>$log_file
    if [ $? -ne 0 ]; then
      useradd ${app_user} &>>$log_file
    fi
    function_stat_check $?

    print_heading "Create application user"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    function_stat_check $?

    print_heading "Download application code"
    curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip &>>$log_file
    function_stat_check $?

    cd /app &>>$log_file

    print_heading "Unzipping shipping zip file"
    unzip /tmp/${component_name}.zip &>>$log_file
    function_stat_check $?
}

function_systemdsetup() {
    print_heading "Copying shipping service file"
    cp $script_path/${component_name}.service /etc/systemd/system/${component_name}.service &>>$log_file
    function_stat_check $?

    print_heading "${component_name} service start"
    cd
    systemctl daemon-reload &>>$log_file
    function_stat_check $?
    systemctl enable ${component_name} &>>$log_file
    function_stat_check $?
    systemctl restart ${component_name} &>>$log_file
    function_stat_check $?
}

function_nodejs (){

  print_heading "Disabling old version and enabling new"
  dnf module disable nodejs -y &>>$log_file
  function_stat_check $?
  dnf module enable nodejs:18 -y &>>$log_file
  function_stat_check $?

  print_heading "Installing Nodejs"
  dnf install nodejs -y &>>$log_file
  function_stat_check $?

  function_prereq

  print_heading "Installing NPM dependenceis"
  npm install &>>$log_file
  function_stat_check $?

  function_schema
  function_systemdsetup
}

function_java() {
    print_heading "Installing maven"
    dnf install maven -y &>>$log_file
    function_stat_check $?

    function_prereq

    print_heading "Download dependencies"
    mvn clean package &>>$log_file
    function_stat_check $?
    mv target/${component_name}-1.0.jar ${component_name}.jar &>>$log_file
    function_stat_check $?

    function_schema
    function_systemdsetup

}


function_python() {
    print_heading "Installing python"
    dnf install python36 gcc python3-devel -y &>>$log_file
    function_stat_check $?

    function_prereq

    print_heading "Installing python dependencies"
    pip3.6 install -r requirements.txt &>>$log_file
    function_stat_check $?

    print_heading "Download dependencies"
    sed -i -e "s|rabbitmq_adduser_password|${rabbitmq_adduser_password}|" $script_path/payment.service &>>$log_file
    function_stat_check $?

    function_systemdsetup
}