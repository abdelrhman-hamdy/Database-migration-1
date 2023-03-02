#!/bin/bash

env_path=ConfigurationManagement/roles/run_Server_client/files/.env


sed -i -E "s/dbusername=.*/dbusername=$DB_USERNAME/" $env_path
sed -i -E "s/dbpassword=.*/dbpassword=$DB_PASSWORD" $env_path
sed -i -E "s/dbhost=.*/dbhost=$mongodb/" $env_path
sed -i -E "s/serverhost=.*/serverhost=$ServerPrivateIp/" $env_path
