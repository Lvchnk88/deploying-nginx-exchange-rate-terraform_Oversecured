provider "aws" {
  # access_key = var.ACCESS_KEY
  # secret_key = var.SECRET_KEY
  region     = "us-east-1"
}

# VPC
resource "aws_vpc" "oversecured_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-oversecured-vpc"
  }
}

# Subnet
resource "aws_subnet" "oversecured_subnet" {
  vpc_id                  = aws_vpc.oversecured_vpc.id
  cidr_block              = "172.16.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "tf-oversecured-subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "oversecured_gw" {
  vpc_id = aws_vpc.oversecured_vpc.id

  tags = {
    Name = "tf-oversecured-gw"
  }
}

# Route table
resource "aws_route_table" "oversecured_public_rtb" {
  vpc_id = aws_vpc.oversecured_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.oversecured_gw.id
  }
  tags = {
    Name = "tf-oversecured-public-rtb"
  }
}

# Route table association
resource "aws_route_table_association" "oversecured_crta_public_subnet" {
  subnet_id      = aws_subnet.oversecured_subnet.id
  route_table_id = aws_route_table.oversecured_public_rtb.id
}

# Security group
resource "aws_security_group" "oversecured_security_group" {
  vpc_id = aws_vpc.oversecured_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key pair
resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)
}

# EC2
resource "aws_instance" "oversecured_test_vm" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.oversecured_subnet.id
  vpc_security_group_ids = ["${aws_security_group.oversecured_security_group.id}"]
  key_name               = aws_key_pair.aws-key.id
  user_data              = file("userdata.tpl")
}

# Route53
data "aws_route53_zone" "hosted_zone" {
  name         = "oversecured.pp.ua"
}

# Record
resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = data.aws_route53_zone.hosted_zone.name
  type    = "A"
  ttl     = "300"
  records = "${aws_instance.oversecured_test_vm.*.public_ip}"
}

output "ec2_global_ips" {
  value = ["${aws_instance.oversecured_test_vm.*.public_ip}"]
}
