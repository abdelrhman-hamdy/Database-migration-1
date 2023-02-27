#!/bin/bash

function checkService {
systemctl is-active --quiet mongod.service                                      # check if the service is up and running
if ($? -eq 0 ); then 
echo "Mongodb Server is Up and Running"
else
echo "Failed to start Mongodb Server"
fi 
}

yum install mongodb-org -y

sed -i -E 's/^  bindIp: (127.0.0.1)/  bindIp: 0\.0\.0\.0/'  /etc/mongod.conf    # configure mongodb to accept requests from any ip 

systemctl daemon-reload  && systemctl enable --now mongod                       # enable and start  mongodb




mongo <<EOF
use admin
db.createUser(
{
user: "$MongoAdminUser",
pwd: "$MongoAdminPass",
roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
}
)
db.createUser({
    user:"$MongoUser",
    pwd : "$MongoPass",
    roles : [{role:"readWrite",db:"server"}]})
EOF


sed -i -E 's/#security:/security: \n   authorization: "enabled" /'  /etc/mongod.conf  # Enable authentication in mongodb server

systemctl restart mongod.service

#sleep 5
checkService
