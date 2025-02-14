app_user=roboshop

print_heading(){
  echo -e "\e[36m>>>>>>>>>>>  $1  <<<<<<<<<<<<<\e[0m"
}

function_stat_check() {
    if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      exit 1
    fi
}

function_schema() {
  if [ "$schema_setup" == "mongo" ]; then

    print_heading "Copying mongo repo file"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo
    function_stat_check $?

    print_heading "Installing mongo client"
    dnf install mongodb-org-shell -y
    function_stat_check $?

    print_heading "Loading the schema"
    mongo --host mongodb-dev.kmvdevops.shop </app/schema/${component_name}.js
    function_stat_check $?

  fi

  if [ "$schema_setup" == "mysql" ]; then

    print_heading "Installing MySQL"
    dnf install mysql -y
    function_stat_check $?

    print_heading "Load schema"
    mysql -h mysql-dev.kmvdevops.shop -uroot -p${mysql_password} < /app/schema/${component_name}.sql
    function_stat_check $?

  fi
}


function_prereq() {
    print_heading "Add roboshop user and app directory"
    useradd ${app_user}
    function_stat_check $?

    rm -rf /app
    mkdir /app
    function_stat_check $?

    print_heading "Download application code"
    curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip
    function_stat_check $?

    cd /app

    print_heading "Unzipping shipping zip file"
    unzip /tmp/${component_name}.zip
    function_stat_check $?
}

function_systemdsetup() {
    print_heading "Copying shipping service file"
    cp $script_path/${component_name}.service /etc/systemd/system/${component_name}.service
    function_stat_check $?

    print_heading "${component_name} service start"
    cd
    systemctl daemon-reload
    function_stat_check $?
    systemctl enable ${component_name}
    function_stat_check $?
    systemctl restart ${component_name}
    function_stat_check $?
}

function_nodejs (){

  print_heading "Disabling old version and enabling new"
  dnf module disable nodejs -y
  function_stat_check $?
  dnf module enable nodejs:18 -y
  function_stat_check $?

  print_heading "Installing Nodejs"
  dnf install nodejs -y
  function_stat_check $?

  function_prereq

  print_heading "Installing NPM dependenceis"
  npm install
  function_stat_check $?

  function_schema
  function_systemdsetup
}

function_java() {
    print_heading "Installing maven"
    dnf install maven -y
    function_stat_check $?

    function_prereq

    print_heading "Download dependencies"
    mvn clean package
    function_stat_check $?
    mv target/${component_name}-1.0.jar ${component_name}.jar
    function_stat_check $?

    function_schema
    function_systemdsetup

}


