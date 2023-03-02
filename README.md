# Database-Migration
 In this project, I'm Building a CI/CD pipeline using Jenkins to Migrate a database cluster from Mongodb engine to Mysql engine with zero downtime by performing lazy migration technique. 

## Note: 
- All resources are created using Terraform
- All configurations are made using Asnible 
- Jenkins, Nodejs server, and clients, all of them are continarized using Docker

# The project is divided into 3 stages:
## Initial phase : 
There is Mock nodejs server that exposes port 8282, once connected, it generates a stream of JSON objects representing shipments data coming from different sources.
In this phase i craeted Mongodb server on EC2 instance. Then Created another EC2 to be the docker host of the continarized nodejs server and Python client-which listens on the port 8282 to get
server's data and insert it to the mongodb -

## Preparing for migration:
In this stage i created Mysql database with RDS AWS , Then created another Python client to get data from nodejs server, and insert it to Mysql database

## Migration:
in this phase, a Database migration should happen form Mongodb to Mysql in zero downtime and without losing any customer data.
### I'm stil working on this phase, once finished, i will update the repo with the needed files and all necessary instructions to run the project
