script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
rabbitmq_adduser_password=$1

if [ -z "$rabbitmq_adduser_password" ]
then
  echo Password not provided
  exit
fi

component_name=payment

function_python


