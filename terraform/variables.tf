
variable "PUBLIC_KEY_PATH" {
  default = "~/.ssh/SERGII_LEVCHENKO_PRIVARE_KEY_RSA.pub"
}

# variable "ACCESS_KEY" {
#   default = "  Your key  "
# }
# variable "SECRET_KEY" {
#   default = "  Your key  "
# }

variable "region" {
  default = "us-east-1"
}

variable "cidr_vpc" {
  default = "172.16.0.0/16"
}

variable "cidr_subnet" {
  default = "172.16.10.0/24"
}

variable "availability_zone" {
  default = "us-east-1b"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "hosted_zone" {
  default = "tf-oversecured.pp.ua"
}

variable "allow_ports" {
  default = ["80", "443", "22"]
}