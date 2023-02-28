 
import mysql.connector
import json
import socket, time
import os 

dbuser=os.getenv('dbusername')
dbpass=os.getenv('dbpassword')
dbhost=os.getenv('dbhost')
ServerHost=os.getenv('serverhost')
mydb = mysql.connector.connect(
  host=dbhost,
  user=dbuser,
  password=dbpass
)
mycursor = mydb.cursor()


mycursor.execute("create database if not exists server")
mycursor.execute("use server")
mycursor.execute("create table if not exists customer (firstName varchar(255), lastName varchar(255), email varchar(255), price int, country varchar(255), city varchar(255), street varchar(255), x float, y float , creationDate varchar(255)   )")
sql = "INSERT INTO customer (firstName , lastName , email , price , country , city , street , x , y , creationDate ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"


client_socket = socket.socket()
client_socket.connect((ServerHost, 8282))
while True:
    time.sleep(0.5)
    data = client_socket.recv(1024).decode().replace('\\n', '\n').replace('\\', '')[4:]
    data= "" + data[1:-1] + ""
    data=data.strip()
    data=json.loads(data,strict=False)
    val = (data['receiver']['firstName'],data['receiver']['lastName'],data['receiver']['email'],data['price'],data['address']['country'],data['address']['city'],data['address']['street'],data['address']['coordinates']['x'],data['address']['coordinates']['y'],data['creationDate'])
    mycursor.execute(sql, val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")