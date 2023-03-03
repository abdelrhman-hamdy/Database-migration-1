#!/bin/bash

#Getting documents total number to make sure that client is inserting data to db
docs_number1=$(mongosh --quiet --host $dbhost -u $dbusername -p $dbpassword --eval 'use server' --eval 'db.customer.countDocuments({})')

echo $docs_number1
# Raise an error in case of empty collection and exit with 1
if [ $docs_number1 -eq 0 ]; then
    echo "TEST FAILED: client doesn't insert data to db"
    exit 1
fi

sleep 5 

# double check that documents number are increasing and not just old inserted data
docs_number2=$(mongosh --quiet --host $dbhost -u $dbusername -p $dbpassword --eval 'use server' --eval 'db.customer.countDocuments({})')

echo $docs_number2

if [ $docs_number1 -eq $docs_number2 ]; then
    echo "TEST FAILED:Client doesn't insert data to db"
    exit 1

    else

 echo "TEST SUCCEEDED: client is inserting data to db"
fi
