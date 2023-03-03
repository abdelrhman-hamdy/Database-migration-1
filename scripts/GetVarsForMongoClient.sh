#!/bin/bash

# you can use this script by providing 2 args,database Password and  which database you are using mongodb or mysql

dbhost=$(grep -A1 $1 ConfigurationManagement/inventory | tail -1)
serverhost=$(grep -A1 ServerPrivateIp ConfigurationManagement/inventory | tail -1)
env_path=ConfigurationManagement/roles/run_Server_client/files/.env
sed -i -E "s/dbusername=.*/dbusername=$DB_USERNAME/" $env_path
sed -i -E "s/dbpassword=.*/dbpassword=$DB_PASSWORD/" $env_path
sed -i -E "s/dbhost=.*/dbhost=$dbhost/" $env_path
sed -i -E "s/serverhost=.*/serverhost=$serverhost/" $env_path
