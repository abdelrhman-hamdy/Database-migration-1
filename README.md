<p align="center">

  ![Database Migration](https://storage.googleapis.com/gweb-cloudblog-publish/images/databases_8QOVRPF.max-2600x2600.jpg)

  </a>
</p>

<h3 align="center">Database Migration</h3>

## Table of contents :
- [Overview](#overview-)
- [Technologies Used](#technologies-used)
- [Before the Project](#before-the-project)


## Overview :
 In this project, I built CI/CD pipeline to Migrate a database cluster from Mongodb engine to Mysql engine with zero-downtime by performing lazy migration technique.

### The project was divided into 3 stages:
* Initial phase :
 This where the legacy system was created, a Mock nodejs server that exposes port 8282, and once connected to a Python client, it generates a stream of JSON objects representing shipments data coming from different sources. The python client then  process this data and inserts it to a Mongodb server

![](https://user-images.githubusercontent.com/69608603/224951862-fa7832d9-5537-4d9a-8074-fa0095dc3225.png)

* Preparing for migration:
In this stage, the New database engine was created which was Mysql besides the Updated version of the Python client. the new and old systems connected  simultaneously with the server

![](https://user-images.githubusercontent.com/69608603/224952493-5c088177-ee30-43cd-afca-754762c20524.png)


## Technologies Used:
- Jenkins
- AWS
- Terraform
- Docker
- Ansible
- Python
- Bash



## NOTE:
 I'm still working on documenting the project








