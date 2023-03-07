import sys
import subprocess

subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pymongo==4.3.3'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'json5==0.9.6'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'mysql-connector==2.2.9'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pandas==1.3.4'])
import pandas as pd 
from pymongo import MongoClient
import json
import socket, time
import mysql.connector
import os 
from bson.objectid import ObjectId

dbuser=os.getenv('DB_USERNAME')
dbpass=os.getenv('DB_PASSWORD')
mysqlhost=os.getenv('mysqlhost')
mongohost=os.getenv('mongohost')

print (dbpass,dbpass,mysqlhost,mongohost)
#Log in Mysql
mysqldb = mysql.connector.connect(
  host=mysqlhost,
  user=dbuser, 
  password=dbpass
)

mycursor = mysqldb.cursor()
# use server database
mycursor.execute("use server;")

# Check if ID column exist and Create one if not, the created column should be nullable or otherwise all applications that deals with the database will crash
#try : 
#  mycursor.execute("SELECT ID FROM customer;")
#except:
#  mycursor.execute("ALTER TABLE customer ADD ID INT  PRIMARY KEY AUTO_INCREMENT;")

# Log in Mongodb
mongoclient = MongoClient(f'mongodb://{dbuser}:{dbpass}@{mongohost}:27017/')
mongodb = mongoclient["server"]
customer_collection = mongodb["customer"]

# mysql and mongo databases ran simultenasly in suring migration, so there are some documents in mongodb that already exist in mysql which we don't want to copy and create duplicates
# so to eliminate this we will grep first row in mysql and query it's mongo
# Get first row in mysql , 
mycursor.execute("SELECT * FROM customer WHERE ID=1;")

for (firstName,lastName, email, price, country, city, street,x,y,creationDate,ID) in mycursor :
    
    doc=customer_collection.find_one({"receiver.firstName":firstName,"receiver.lastName": lastName,"receiver.email" :email,
            "price":price,"address.city":city,"address.country":country,"address.street":street,"address.coordinates.x":x,
            "address.coordinates.y":y,"creationDate":creationDate},{"_id": 1 })

    for id in doc:
      first_overlapped_row_id=id['_id']  

objInstance = ObjectId(first_overlapped_row_id)
# Get total number of Documents
docs_num=customer_collection.count_documents({"_id":{"$lt": objInstance}})

# Get all mongodb old data
mydoc = customer_collection.find({"_id":{"$lt": objInstance}})


# I want the old data from mongodb to be inserted at the top of mysql table -because it's the old data- ,so it will be done in two steps
# first step is to update all ID values to be ID = ID + mongo_old_data_rows_number
# second step is inserting mongodb old data starting from id value 1 to mongo_old_data_rows_number

# Update table ID values  to insert the old mongodb data at the top of cutomer table
mycursor.execute("UPDATE customer SET ID = ID + {} WHERE ID >= 1 ORDER BY ID DESC;".format(docs_num))


sql = "INSERT INTO customer (ID, firstName , lastName , email , price , country , city , street , x , y , creationDate ) VALUES (%s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

list_of_ids=[]

ID=0
for data in mydoc: #looping through mongodb documents

    ID = ID + 1

    #changing schema from json to list of objects
    val=(ID,data['receiver']['firstName'],data['receiver']['lastName'],data['receiver']['email'],data['price'],data['address']['country'],data['address']['city'],data['address']['street'],data['address']['coordinates']['x'],data['address']['coordinates']['y'],data['creationDate'])
    
    #inserting the mongodb doucment as a row in mysql
    mycursor.execute(sql, val)
    mysqldb.commit()
    print(mycursor.rowcount, "record inserted.")
    list_of_ids.append(data['_id'])

df = pd.DataFrame(list_of_ids,columns =['ID'])
df.to_csv('mongodb_ids.csv',index=False)