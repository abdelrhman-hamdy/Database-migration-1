terraform {
  required_version = ">= 0.14.9"
}
resource "aws_security_group" "JenkinsSecGroup" {
  name= var.secgroupname
  //Allow ssh on port 22 , jenkins server on 8080, and  all outbound ports
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  ingress { 
  cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  }
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 
  
  
}


resource "aws_instance" "JenkinsServer" {
    ami= var.ami
    instance_type = var.itype
    tags = {
      "Name" = var.EC2name 
    }
    key_name = var.keyname
    associate_public_ip_address = var.publicip
    vpc_security_group_ids = [
        aws_security_group.JenkinsSecGroup.id
    ]
    
    depends_on = [ aws_security_group.JenkinsSecGroup ]
}

