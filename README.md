Test Task for Oversecured
-------------------------


Clone repository
----------------

```
$ git clone https://github.com/Lvchnk88/test_task_for_oversecured.git
$ cd test_task_for_oversecured
```

Terraform Deployment
--------------------

1. Run this commands to authenticate in AWS:

```
export AWS_ACCESS_KEY_ID= < Your aws access key >
export AWS_SECRET_ACCESS_KEY= < Your aws secret access key >
```

2. Update terraform/userdata.tpl file with preferences

```
region            = "us-east-1"
availability_zone = "us-east-1b"
cidr_vpc          = "172.16.0.0/16"
cidr_subnet       = "172.16.10.0/24"
instance_type     = "t2.micro"
hosted_zone       = "tf-oversecured.pp.ua"
allow_ports       = ["80", "443", "22"]
```

4. Turn On/Off SSL in terraform/variables.tf file

```
variable "userdata_vars" {
  default = {
    enable_nginx_ssl  = false <= false/true
    domain_name       = null  <= nul/your.domain.com
  }
  type = object({
    enable_nginx_ssl  = bool
    domain_name       = string
  })
}
```

5. Run Terraform commands to deploy the infrastructure:

```
$ cd terraform
$ terrafirm init
$ terraform plan
$ terraform apply
```

6. After the deployment is complete, you will see the output with the IP address, login, and password:

```
ec2_global_ips = [
  [
    "52.207.129.65",
  ],
]
login = "New_User_Name"
password = "New_User_Name_Password"
``` 



License
-------

Terraform v1.5.0

This project is licensed under the [MIT License](LICENSE).