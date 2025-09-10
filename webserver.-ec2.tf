terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Specifies the source (e.g., hashicorp/aws)
      version = "~> 5.0"         # Defines a version constraint
    }
  }
}

  provider "aws" {
  region     = "ap-south-1"          # Replace with your desired AWS region (e.g., "us-west-2", "eu-west-1")
  }

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a" # Replace with your desired AZ
  map_public_ip_on_launch = true # Allows instances in this subnet to get public IPs
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "ec2-security-group"
  description = "Allows SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with 0.0.0.0/0 in production
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with 0.0.0.0/0 in production
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2SecurityGroup"
  }
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0f918f7e67a3323f0" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ec2_sg.id] # Use name for security group association
  key_name      = "test090" # Replace with your existing EC2 key pair name

  tags = {
    Name = "jenkins-slave2"
  }
}
