
 variable "ami" {
    type = string
    description = " EC2 Instance's AMI"
  
}
 variable "itype" {
    type = string
    description = "EC2 Instance's type"
    default = "t2.micro"
}
 variable "publicip" {
    type = bool 
    description = "PublicIP for EC2"
  
}
 variable "keyname" {
    type = string
    description = "EC2 Access Key"
  
}
 variable "secgroupname" {
    type = string
    description = "secgroupname"
  
}
 variable "EC2name" {
    type = string
    description = "EC2 Instance name"
  
}

