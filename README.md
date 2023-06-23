Test Task for Oversecured
-------------------------


Clone repository
----------------

```
$ git clone https://github.com/<username>/test_task_for_oversecured.git
$ cd test_task_for_oversecured
```

Terraform Deployment
--------------------

1. Run Terraform commands to deploy the infrastructure:

```
$ cd terraform
$ terrafirm init
$ terraform plan
$ terraform apply
```

2. After the deployment is complete, you will see the output with the IP address, login, and password:

```
ec2_global_ips = [
  [
    "52.207.129.65",
  ],
]
login = "New_User_Name"
password = "New_User_Name_Password"
```

HTTPS Configuration
-------------------

If you want to register a domain name for HTTPS, follow these additional steps:

1. Rename the file "default_for_https" to "default".

2. Uncomment the necessary lines in the "userdata" file.

License
-------

This project is licensed under the [MIT License](LICENSE).