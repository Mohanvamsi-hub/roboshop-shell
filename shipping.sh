script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_password=$1


if [ -z "$mysql_password" ]
then
  echo Password not provided
  exit
fi

component_name=shipping
schema_setup=mysql
function_java

