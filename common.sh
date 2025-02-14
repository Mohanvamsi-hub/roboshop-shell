app_user=roboshop

print_heading(){
  echo -e "\e[36m>>>>>>>>>>>  $1  <<<<<<<<<<<<<\e[0m"
}

function_nodejs (){
  print_heading "Disabling old version and enabling new"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  print_heading "Installing Nodejs"
  dnf install nodejs -y

  print_heading "Adding roboshop user"
  useradd ${app_user}

  print_heading "Adding roboshop user"
  rm -rf /app
  mkdir /app

  print_heading "Downloading zip file"
  curl -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip
  cd /app

  print_heading "Unzipping file contents"
  unzip /tmp/${component_name}.zip

  print_heading "Installing NPM dependenceis"
  npm install

  print_heading "copying service file"
  cp $script_path/${component_name}.service /etc/systemd/system/${component_name}.service


  print_heading "Enabling catalogue service"
  cd
  systemctl daemon-reload
  systemctl enable ${component_name}
  systemctl restart ${component_name}
}