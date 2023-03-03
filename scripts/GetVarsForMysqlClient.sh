#!/bin/bash

cd /IaC/dev
dbhost=$(terraform output | grep -oE "mysql-database.*\.com")
serverhost=$(grep -A1 ServerPrivateIp ConfigurationManagement/inventory | tail -1)

cd ../..

path=ConfigurationManagement/roles/run_Server_client/files/.env

sed -i -E "s/dbusername=.*/dbusername=$DB_USERNAME/" $env_path
sed -i -E "s/dbpassword=.*/dbpassword=$DB_PASSWORD/" $env_path
sed -i -E "s/dbhost=.*/dbhost=$dbhost/" $env_path
sed -i -E "s/serverhost=.*/serverhost=$serverhost/" $path

