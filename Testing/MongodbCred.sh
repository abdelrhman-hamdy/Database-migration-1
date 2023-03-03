#!/bin/bash
export dbusername=$(grep dbusername ConfigurationManagement/roles/run_Server_client/files/.env | cut -d= -f2)
export dbpassword=$(grep dbpassword ConfigurationManagement/roles/run_Server_client/files/.env | cut -d= -f2)
export dbhost=$(grep dbhost ConfigurationManagement/roles/run_Server_client/files/.env | cut -d= -f2)
