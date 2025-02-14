app_user=roboshop

print_heading(){
  echo -e "\e[36m>>>>>>>>>>>  $1  <<<<<<<<<<<<<\e[0m"
}

function_schema() {
  if [ "$schema_setup" == "mongo" ] then
  {
    print_heading "Copying mongo repo file"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

    print_heading "Installing mongo client"
    dnf install mongodb-org-shell -y

    print_heading "Loading the schema"
    mongo --host mongodb-dev.kmvdevops.shop </app/schema/${component_name}.js
    }
  fi

  if [ "$schema_setup" == "mysql" ] then
  {
    print_heading "Installing MySQL"
    dnf install mysql -y

    print_heading "Load schema"
    mysql -h mysql-dev.kmvdevops.shop -uroot -p${mysql_password} < /app/schema/${component_name}.sql

  }
  fi
}


function_prereq() {
    print_heading "Add roboshop user and app directory"
    useradd ${app_user}
    rm -rf /app
    mkdir /app

    print_heading "Download application code"
    curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip
    cd /app

    print_heading "Unzipping shipping zip file"
    unzip /tmp/${component_name}.zip
}

function_systemdsetup() {
    print_heading "Copying shipping service file"
    cp $script_path/${component_name}.service /etc/systemd/system/${component_name}.service

    print_heading "${component_name} service start"
    cd
    systemctl daemon-reload
    systemctl enable ${component_name}
    systemctl restart ${component_name}
}

function_nodejs (){
  print_heading "Disabling old version and enabling new"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  print_heading "Installing Nodejs"
  dnf install nodejs -y

  function_prereq

  print_heading "Installing NPM dependenceis"
  npm install

  function_schema
  function_systemdsetup
}

function_java() {
    print_heading "Installing maven"
    dnf install maven -y

    function_prereq

    print_heading "Download dependencies"
    mvn clean package
    mv target/${component_name}-1.0.jar ${component_name}.jar

    function_schema
    function_systemdsetup

}


