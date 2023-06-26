
PUBLIC_KEY_PATH = "~/.ssh/SERGII_LEVCHENKO_PRIVARE_KEY_RSA.pub"

# ACCESS_KEY = "  Your key  "
# SECRET_KEY = "  Your key  "

region            = "us-east-1"
availability_zone = "us-east-1b"
cidr_vpc          = "172.16.0.0/16"
cidr_subnet       = "172.16.10.0/24"
instance_type     = "t2.micro"
hosted_zone       = "tf-oversecured.pp.ua"
allow_ports       = ["80", "443", "22"]