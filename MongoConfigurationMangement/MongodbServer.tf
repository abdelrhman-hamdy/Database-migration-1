terraform {
    required_providers {
      aws = {
	      source = "hashicorp/aws"
	      version = "~> 3.27"
      }
    }
  required_version = ">= 0.14.9"
}
variable "awsVars" {
    type = map
    default = {
    region = "us-east-1"
    ami= "ami-0aa7d40eeae50c9a9"
    itype = "t2.micro"
    publicip = true
    keyname = "hamdy_key"
    secgroupname = "MongoServerSecGroup"
    EC2name=  "MongodbServer"

}
}
provider "aws" {
}

resource "aws_security_group" "MongoServerSecGroup" {
  name= lookup(var.awsVars,"secgroupname")

  //Allow ssh on port 22 , and  all outbound ports
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 27017
    protocol = "tcp"
    to_port = 27017
  }
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
}

resource "aws_instance" "MongodbServer" {
    ami= lookup(var.awsVars,"ami")
    instance_type = lookup(var.awsVars,"itype")
    tags = {
      "Name" = lookup(var.awsVars,"EC2name")
    }
    key_name = lookup(var.awsVars,"keyname")
    associate_public_ip_address = lookup(var.awsVars,"publicip")
    vpc_security_group_ids = [
        aws_security_group.MongoServerSecGroup.id
    ]

    depends_on = [ aws_security_group.MongoServerSecGroup ]
}

output "MongodbServerIP" {
    value = aws_instance.MongodbServer.public_ip
}