provider "aws" {
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY
  region     = "us-east-1"
}

resource "aws_vpc" "oversecured_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-oversecured-vpc"
  }
}

resource "aws_subnet" "oversecured_subnet" {
  vpc_id                  = aws_vpc.oversecured_vpc.id
  cidr_block              = "172.16.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "tf-oversecured-subnet"
  }
}

resource "aws_internet_gateway" "oversecured_gw" {
  vpc_id = aws_vpc.oversecured_vpc.id

  tags = {
    Name = "tf-oversecured-gw"
  }
}

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

resource "aws_route_table_association" "oversecured_crta_public_subnet" {
  subnet_id      = aws_subnet.oversecured_subnet.id
  route_table_id = aws_route_table.oversecured_public_rtb.id
}

====== continue ========

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.it_craft.id
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

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.test_subnet.id
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name               = aws_key_pair.aws-key.id
  user_data              = file("userdata.tpl")
}

output "ec2_global_ips" {
  value = ["${aws_instance.nginx_server.*.public_ip}"]
}
