#!/bin/bash
export dbhost=$(grep dbhost ConfigurationManagement/roles/run_Server_client/files/.env | cut -d= -f2)
