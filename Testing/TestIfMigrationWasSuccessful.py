import sys
import subprocess

subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pymongo==4.3.3'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'json5==0.9.6'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'mysql-connector==2.2.9'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pandas==1.3.4'])

import pandas as pd 
from  random import randint
from pymongo import MongoClient
import os 
from bson.objectid import ObjectId
import mysql.connector

dbuser=os.getenv('DB_USERNAME')
dbpass=os.getenv('DB_PASSWORD')
mongohost=os.getenv('mongohost')
mysqlhost=os.getenv('mysqlhost')

mongoclient = MongoClient(f'mongodb://{dbuser}:{dbpass}@{mongohost}:27017/')
mongodb = mongoclient["server"]
customer_collection = mongodb["customer"]

mysqldb = mysql.connector.connect(
  host=mysqlhost,
  user=dbuser, 
  password=dbpass
)

mycursor = mysqldb.cursor()
# use server database
mycursor.execute("use server;")


   
df = pd.read_csv('mongodb_ids.csv')

df_rows = df.shape[0]

for i in range(100):
    random_index = randint(0,df_rows-1)
    id=df.iloc[random_index].values[0]
    print("THE ID: ",id)
    objInstance = ObjectId(id)
    mongo_doc=customer_collection.find_one({"_id":objInstance})
    print('FIRSTNAME OF THE ID',mongo_doc["receiver"]["firstName"])
    mycursor.execute(f'SELECT EXISTS(SELECT * FROM customer WHERE firstName="{mongo_doc["receiver"]["firstName"]}" AND  lastName="{mongo_doc["receiver"]["lastName"]}" AND  email="{mongo_doc["receiver"]["email"]}" AND price={mongo_doc["price"]} AND country="{mongo_doc["address"]["country"]}" AND city="{mongo_doc["address"]["city"]}" AND  street="{mongo_doc["address"]["street"]}" AND x={mongo_doc["address"]["coordinates"]["x"]} AND y={mongo_doc["address"]["coordinates"]["y"]} AND creationDate="{mongo_doc["creationDate"]}" );')
    row_exist=mycursor.fetchone()
    if not row_exist : 
        print(f'FAILED :the Query number:{i} did not found, quitting.....')
        raise Exception()
    
print(f'SUCCESSFUL : a {i} queries were done and all of them were SUCCESSFUL.')
    