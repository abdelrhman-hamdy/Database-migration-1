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
  keyname = "hamdy_key"
  secgroupname = "JenkinsSecGroup"
  EC2name=  "JenkinsServer" 
}

module "MosckServer" {
  source = "../modules/MockServer"
  ami= "ami-09cd747c78a9add63"
  itype = "t2.micro"
  publicip = true
  keyname = "hamdy_key"
  secgroupname = "MockServerSecGroup"
  EC2name=  "MosckServer" 
}

module "MongodbServer" {
  source = "../modules/Mongodb"
    ami= "ami-0aa7d40eeae50c9a9"
    itype = "t2.micro"
    publicip = true
    keyname = "hamdy_key"
    secgroupname = "MongoServerSecGroup"
    EC2name=  "MongodbServer"

}

output "jenkins" {
  value = module.JenkinsServer.JenkinsServer.public_ip
}
output "mockserver" {
  value = module.MosckServer.MosckServer.public_ip
}
output "mongodb" {
  value = module.MongodbServer.MongodbServer.public_ip
}