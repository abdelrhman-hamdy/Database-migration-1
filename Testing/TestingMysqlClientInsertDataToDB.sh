#!/bin/bash

value=$(mysql -h $dbhost  -u $DB_USERNAME -p$DB_PASSWORD -e "USE server;SELECT COUNT(*) FROM customer ;")

rows_number1=$(echo $value | cut -d' ' -f2)
echo $rows_number1

# Raise an error in case of empty table and exit with 1
if [ $rows_number1 -eq 0 ]; then
    echo "TEST FAILED: client doesn't insert data to db"
    exit 1
fi

sleep 5

# double check that documents number are increasing and not just old inserted data
value=$(mysql -h $dbhost  -u $DB_USERNAME -p$DB_PASSWORD -e "USE server;SELECT COUNT(*) FROM customer ;")

rows_number2=$(echo $value | cut -d' ' -f2)
echo $rows_number2

if [ $rows_number1 -eq $rows_number2 ]; then
    echo "TEST FAILED:Client doesn't insert data to db"
    exit 1

    else

 echo "TEST SUCCEEDED: client is inserting data to db"
fi
