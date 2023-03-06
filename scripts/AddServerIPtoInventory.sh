#!/bin/bash

# this script takes the ouptut of terraform - which is a Server IP-  and modify or add it if doesn't exist to the inventory file
# you can call the script by providing 2 args , the server name in the inventory file and the location of the inventory file
# EXPAMPLE  : ./AddServerIPtoInventory.sh Mongodb ./inventory
# the terraform output variable should be the same  name as in the inventory

#for last_arg in $@; do true; done   # get the last passed argument, did this way to work with sh , if the script will be executed in bash

for input in $@
do
if [ $input == ${@: -1} ];then break; fi    # the last argument is the location on inventory file , the exit the loop if you reached to this arg

ServerIP=$(terraform output | grep $input | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
if [ ! -e ${@: -1} ];then                                             # Create the inventory file if doesn't exist
    touch ${@: -1}
fi

IP_line_number=$(grep -A1 -n $input ${@: -1} | tail -1  | cut -d- -f1)    # Grep the line number of the Server IP form the inventory

if [ ! -z $IP_line_number  ]; then

sed -i -E "$IP_line_number s/.*/$ServerIP/" ${@: -1}                 # modify the IP with the new one

else
    echo "[$input]" >> ${@: -1}                                          # Add the IP to the file if doesn't exist
    echo $ServerIP >> ${@: -1}
fi

done
