from pymongo import MongoClient
import json
import socket, time,os 

dbuser=os.getenv('dbusername')
dbpass=os.getenv('dbpassword')
dbhost=os.getenv('dbhost')
ServerHost=os.getenv('serverhost')
print(f'mongodb://{dbuser}:{dbpass}@{dbhost}:27017/?authSource=admin')
client = MongoClient(f'mongodb://{dbuser}:{dbpass}@{dbhost}:27017/?authSource=admin')
mydb = client["server"]
mycol = mydb["customer"]

count=0
client_socket = socket.socket()
client_socket.connect((ServerHost, 8282))
while True:
    time.sleep(0.5)
    data = client_socket.recv(1024).decode().replace('\\n', '\n').replace('\\', '')[4:]
    data1= "" + data[1:-1] + ""
    data1=data1.strip()
    data1=json.loads(data1,strict=False)
    x = mycol.insert_one(data1)
    print(x.inserted_id)    
    
