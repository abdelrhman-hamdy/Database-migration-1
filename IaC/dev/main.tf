terraform {
    required_providers {
      aws = {
	      source = "hashicorp/aws"
	      version = "~> 3.27"
      }
    }
  required_version = ">= 0.14.9"
}
provider "aws" {
    region = "us-east-1"
    profile = "default"
}

module "JenkinsServer" {
  source = "../modules/CI-CD"
  ami= "ami-09cd747c78a9add63"
  itype = "t3.small"
  publicip = true
  keyname = var.keyname
  secgroupname = "JenkinsSecGroup"
  EC2name=  "JenkinsServer" 
}

module "MockServer" {
  source = "../modules/MockServer"
  ami= "ami-09cd747c78a9add63"
  itype = "t2.micro"
  publicip = true
  keyname = var.keyname
  secgroupname = "MockServerSecGroup"
  EC2name=  "MosckServer" 
}

module "MongodbServer" {
  source = "../modules/Mongodb"
    ami= "ami-0aa7d40eeae50c9a9"
    itype = "t2.micro"
    publicip = true
    keyname = var.keyname
    secgroupname = "MongoServerSecGroup"
    EC2name=  "MongodbServer"

}

module "Mysql" {
  source = "../modules/Mysql"
  db_username=var.db_username
  db_password=var.db_password

}


output "jenkins" {
  value = module.JenkinsServer.JenkinsServer.public_ip
}
output "mockserver" {
  value = module.MockServer.MockServer.public_ip
}

output "ServerPrivateIp" {
  value = module.MockServer.MockServer.private_ip
}

output "mongodb" {
  value = module.MongodbServer.MongodbServer.public_ip
}


output "Mysql_endpoint" {
  value = module.Mysql.mysql-database.endpoint
}
