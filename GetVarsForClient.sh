#!/bin/bash

# you can use this script by providing 2 args,database Password and  which database you are using mongodb or mysql



dbpassword=$1

dbhost=$(grep -A1 $2 ConfigurationManagement/inventory | tail -1)
serverhost=$(grep -A1 mockserver ConfigurationManagement/inventory | tail -1)

env_path=ConfigurationManagement/roles/run_Server_client/files/.env

sed -i -E "s/dbpassword=.*/dbpassword=$dbpassword/" $env_path
sed -i -E "s/dbhost=.*/dbhost=$dbhost/" $env_path
sed -i -E "s/serverhost=.*/serverhost=$serverhost/" $env_path
