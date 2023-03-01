#!/bin/bash
crontab -l | grep "docker-compose"

if [ $? -eq 1 ]; then
    crontab -l > file
    echo "@reboot /usr/bin/docker-compose  -f /home/ubuntu/docker-compose.yaml up -d " >> file
    crontab file
fi 
