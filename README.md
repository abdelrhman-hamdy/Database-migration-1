<h3 align="center">Database Migration</h3>

## Table of contents :
- [Overview](#overview-)
- [Technologies and Tools](#technologies-and-tools)
- Jenkins workflow
- [Prerequisites](#prerequisites)
- [Run the Project](#run-the-project)


## Overview :
 In this project, I built CI/CD pipeline that mimic database Migration from MongoDB(NOSQL)to Mysql(SQL) with zero-downtime.

### The project was divided into 5 stages:
* #### Stage 1 : Building the old system  
  This where the legacy system -which the migration will happen from - was created, a Mock nodejs server that exposes port 8282, and once connected to a Python client, it generates a stream of JSON objects representing shipments data coming from different sources. The python client then  process this data and inserts it to a Mongodb server

<p align="center">
<img  src="https://user-images.githubusercontent.com/69608603/224951862-fa7832d9-5537-4d9a-8074-fa0095dc3225.png" alt="centered image" height="200">
</p>

* #### Stage 2: Deploy the new database and the updated client to production 
  In this stage, the new and old systems are connected at the same time.Then a test is applied to make sure that data is safely inserted and retreived using the new system 
<p align="center">
<img  src="https://user-images.githubusercontent.com/69608603/224952493-5c088177-ee30-43cd-afca-754762c20524.png" alt="centered image" height="400">
</p>

* #### Stage 3 : Making the new database the primary one and transforming the “old” database to a “read-only” database
  After testing the new system, we can disconnect the old client version. Since the “new” database still does not have all the records we will still       need to read from the “old” database as well as from the new .
 
 <p align="center">
<img  src="https://user-images.githubusercontent.com/69608603/225617816-370ebe50-e802-4c41-b5bb-8599408caea8.png" alt="centered image" height="300">
</p>

* #### Stage 4 : Eagerly migrating data from the “old” database to the “new” one 
  a python script is applied to get all old  records that exists in MongoDB, changes its structure, and inserts it in MySQL 
 
 <p align="center">
<img  src="https://user-images.githubusercontent.com/69608603/225621522-4748e48b-82c1-4bd8-a522-0459e125301d.png" alt="centered image" height="400">
</p>
 
* #### Stage 5 : Cleanup 
  Now we can safely delete or archive the MongoDB

<p align="center">
<img  src="https://user-images.githubusercontent.com/69608603/225624363-15735379-6b75-44aa-ba38-42d98b10a8b2.png" alt="centered image" height="200">
</p>


## Technologies and Tools:
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a> 
<a href="https://www.jenkins.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg" alt="jenkins" width="40" height="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a><a href="https://www.gnu.org/software/bash/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" alt="bash" width="40" height="40"/> </a><a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a>
<a><img src="https://assets-global.website-files.com/5f10ed4c0ebf7221fb5661a5/5f2f44a3fe54f0baba461524_terraform-logo.png" alt="Terraform" width="40" height="40"/> </a><a><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyHc8dI66EQS-Jrtpl1fp7emOW3Q1ApqjytOW4uGu3vQLHu3m2oWWk2cZ0_vDnvzvJibg&usqp=CAU" alt="Ansible" width="40" height="40"/> </a>

## Prerequisites 

## Run the Project

## NOTE:
 I'm still working on documenting the project








 
