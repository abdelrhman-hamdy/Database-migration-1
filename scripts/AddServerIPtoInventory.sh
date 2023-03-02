#!/bin/bash

# this script takes the ouptut of terraform - which is a Server IP-  and modify or add it if doesn't exist to the inventory file
# you can call the script by providing 2 args , the server name in the inventory file and the location of the inventory file
# EXPAMPLE  : ./AddServerIPtoInventory.sh Mongodb ./inventory

echo $1
ServerIP=$(terraform output | grep $1 | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
if [ ! -e $2 ];then                                             # Create the inventory file if doesn't exist
    touch $2
fi

IP_line_number=$(grep -A1 -n $1 $2 | tail -1  | cut -d- -f1)    # Grep the line number of the Server IP form the inventory

if [ ! -z $IP_line_number  ]; then

sed -i -E "$IP_line_number s/.*/$ServerIP/" $2                    # modify the IP with the new one

else
    echo "[$1]" >> $2                                           # Add the IP to the file if doesn't exist
    echo $ServerIP >> $2
fi



echo $ServerIP
