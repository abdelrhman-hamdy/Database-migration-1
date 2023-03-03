#!/bin/bash

cd IaC/dev/

dbhost=$(terraform output | grep -oE "mysql-database.*\.com")

cd ../../

serverhost=$(grep -A1 ServerPrivateIp ConfigurationManagement/inventory | tail -1)

env_path=ConfigurationManagement/roles/run_mysql_client/files/.Mysqlenv
sed -i -E "s/dbusername=.*/dbusername=$DB_USERNAME/" $env_path
sed -i -E "s/dbpassword=.*/dbpassword=$DB_PASSWORD/" $env_path
sed -i -E "s/dbhost=.*/dbhost=$dbhost/" $env_path
sed -i -E "s/serverhost=.*/serverhost=$serverhost/" $env_path

