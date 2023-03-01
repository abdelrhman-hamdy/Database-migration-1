terraform {
  required_version = ">= 0.14.9"
}
resource "aws_security_group" "MockServerSecGroup" {
  name= var.secgroupname

  //Allow ssh on port 22 , and  all outbound ports
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 
}

resource "aws_instance" "MockServer" {
    ami= var.ami
    instance_type =var.itype
    tags = {
      "Name" = var.EC2name
    }
    key_name = var.keyname
    associate_public_ip_address = var.publicip
    vpc_security_group_ids = [
        aws_security_group.MockServerSecGroup.id
    ]
    
    depends_on = [ aws_security_group.MockServerSecGroup ]
}

