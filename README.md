<p align="center">

  ![Database Migration](https://storage.googleapis.com/gweb-cloudblog-publish/images/databases_8QOVRPF.max-2600x2600.jpg)

  </a>
</p>

<h3 align="center">Database Migration</h3>

## Table of contents :
- [Overview](#overview-)
- [Technologies Used](#technologies-used)
- [prerequisite](#prerequisite)
- []


## Overview :
 In this project, I built CI/CD pipeline mimic database Migration from MongoDB(NOSQL)to Mysql(SQL) engine with zero-downtime by performing lazy migration technique.

### The project was divided into stages:
* #### Stage 1 : Building the old system  
 This where the legacy system -where the migration will happen from - was created, a Mock nodejs server that exposes port 8282, and once connected to a Python client, it generates a stream of JSON objects representing shipments data coming from different sources. The python client then  process this data and inserts it to a Mongodb server

![](https://user-images.githubusercontent.com/69608603/224951862-fa7832d9-5537-4d9a-8074-fa0095dc3225.png)

* #### Stage 2: Deploy the new database and the updated client to production
In this stage, the new and old systems are connected at the same time.Then a test is applied to make sure that data is safely inserted and retreived using the new system 

![](https://user-images.githubusercontent.com/69608603/224952493-5c088177-ee30-43cd-afca-754762c20524.png)

* #### Stage 3 : Making the new database the primary one and  transforming the “old” database to a “read-only” database
 After testing the new system, we can disconnect the old client version. Since the “new” database still does not have all the records we will still need to read from the “old” database as well as from the new .
 
* #### Stage 4 :Eagerly migrate data from the “old” database to the “new” one 
 Here, i python script is applied to get all old  data that exists in MongoDB, change its structure and insert it in MySQL 
 
* #### Stage 5 : Cleanup 

## Technologies Used:
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a> 
<a href="https://www.jenkins.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg" alt="jenkins" width="40" height="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a><a href="https://www.gnu.org/software/bash/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" alt="bash" width="40" height="40"/> </a><a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a>
<a><img src="https://assets-global.website-files.com/5f10ed4c0ebf7221fb5661a5/5f2f44a3fe54f0baba461524_terraform-logo.png" alt="Terraform" width="40" height="40"/> </a><a><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyHc8dI66EQS-Jrtpl1fp7emOW3Q1ApqjytOW4uGu3vQLHu3m2oWWk2cZ0_vDnvzvJibg&usqp=CAU" alt="Ansible" width="40" height="40"/> </a>


## NOTE:
 I'm still working on documenting the project








 
