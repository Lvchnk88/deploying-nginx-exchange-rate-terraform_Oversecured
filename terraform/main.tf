provider "aws" {
  # access_key = var.ACCESS_KEY
  # secret_key = var.SECRET_KEY
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      Envrinment = "test_task"
      Service    = "exchange rate"
      Client     = "oversecured"
    }
  }
}

# VPC
resource "aws_vpc" "oversecured_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true

  tags = {
    Name = "tf-oversecured-vpc"
  }
}

# Subnet
resource "aws_subnet" "oversecured_subnet" {
  vpc_id                  = aws_vpc.oversecured_vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone

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

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-oversecured_security_group"
  }
}


# Key pair
resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)
}

# EC2
resource "aws_instance" "oversecured_test_vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.oversecured_subnet.id
  vpc_security_group_ids = ["${aws_security_group.oversecured_security_group.id}"]
  key_name               = aws_key_pair.aws-key.id
  user_data              = file("userdata.tpl")
  tags = {
    Name = "tf-oversecured-test-vm"
  }
}


# Route53
resource "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}

# Add A record
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = aws_route53_zone.hosted_zone.name
  type    = "A"
  ttl     = "300"
  records = aws_instance.oversecured_test_vm.*.public_ip
}


# Create IAM user add
resource "aws_iam_user" "oversecured_user" {
  name          = var.user
  force_destroy = true
}

resource "aws_iam_user_login_profile" "oversecured_user" {
  user = aws_iam_user.oversecured_user.name
}

# Create access key
# resource "aws_iam_access_key" "oversecured_user" {
#   user = aws_iam_user.oversecured_user.name
# }

# Create group
resource "aws_iam_group" "oversecured_group" {
  name = var.group
}

# Add users to group
resource "aws_iam_user_group_membership" "add_user" {
  user = aws_iam_user.oversecured_user.name
  groups = [
    aws_iam_group.oversecured_group.name
  ]
}

# Custom policy
resource "aws_iam_policy" "oversecured_policy" {
  name        = "tf_SG_Edit_permission"
  description = "Created with Terraform Provide ability to add sg to ec2"
  policy      = var.custom_policy
}

# Custom policy attachment
resource "aws_iam_group_policy_attachment" "custom_policy_attach" {
  group      = aws_iam_group.oversecured_group.name
  policy_arn = aws_iam_policy.oversecured_policy.arn
}

resource "aws_iam_group_policy_attachment" "managet_policy_attach" {
  group      = aws_iam_group.oversecured_group.name
  policy_arn = var.managet_policy
}