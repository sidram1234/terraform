# terraform
new repo
terraform {
  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 4.16"

    }
  }



  required_version = ">= 1.2.0"

}

provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"    
    
    tags = {
      Name = "main"
    }
}

resource "aws_subnet" "public_subnet_1"{
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_Subnet_1_cidr_block
    map_public_ip_on_launch = "true" 
    availability_zone = "us-east-2a"

    tags = {
      Name = "public_subnet_1"
    }
}

resource "aws_subnet" "private_subnet_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_Subnet_2_cidr_block
    map_public_ip_on_launch = "true" 
    availability_zone = "us-east-2a"

    tags = {
      Name = "private_subnet_2"
    }
}

resource "aws_internet_gateway" "prod-igw"{
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "prod-igw"
    }
} 

resource "aws_route_table" "public-crt"{
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = var.public_crt_cidr_block 
        gateway_id = aws_internet_gateway.prod-igw.id 
    }
    
    tags = {
        Name = "public-crt"
    }
}

resource "aws_route_table_association" "public_subnet_1"{
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public-crt.id
}    

resource "aws_eip" "demo-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway"{
  allocation_id = aws_eip.demo-eip.id
  subnet_id     = aws_subnet.private_subnet_2.id


  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_iam_user_policy" "new" {
  name = "S3-bucket-fullaccess"
  user = aws_iam_user.new.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user" "new" {
  name = "new"
  path = "/system/"
}

resource "aws_iam_access_key" "new" {
  user = aws_iam_user.new.name
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "new" {
  ami           = var.aws_instance_new_ami_id
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}

Variable.tf 

variable "instance_type" {
    type        =  string
    default     = "t2.micro"
}

variable "instance_username" {
  type = string
  default = "new"
}

variable "aws_instance_new_ami_id" {
    type = string
    default = "ami-050d94cbfc76a73bf"
}    

variable "key_type" {
    type = string
    default = "Access-key"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "192.164.0.0/24"
   description = "The IPv4 CIDR block for the VPC"
}

variable "private_subnets" {
  type = map(number)
  default = {
    "us-east-2a" = 1
  }
  description = "Map of AZ to a number that should be used for private subnets"
}

## Public Subnet CIDR BLOCK
variable "public_subnets" {
  type = map(number)
  default = {
    "us-east-2a" = 1
  }
  description = "Map of AZ to a number that should be used for public subnets"
}

variable "public_Subnet_1_cidr_block" {
    type = string
    default = "192.164.0.0/25"
}

variable "private_Subnet_2_cidr_block" {
    type = string
    default = "192.164.0.128/25"
}

variable "aws_vpc_main_id" {
    type = string
    default = "vpc-00c0ccdb3a6fde17e"
}

variable "public_crt_cidr_block" {
    type = string
    default = "0.0.0.0/0"  
}

output.tf
output "igw_id" {
  value = aws_internet_gateway.prod-igw.id 
}

output "vpc_id"{
    value = aws_vpc.main.id
}

output "public_subnet1_id" {
    value = aws_subnet.public_subnet_1.id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnet_2.id
}  

output.tf
 "nat-gateway_id" {
  value = aws_nat_gateway.nat-gateway.id
}

output "aws_instance_id" {
    value = aws_instance.new.id
}    
  




