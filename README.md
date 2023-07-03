Test Task for Oversecured
-------------------------

Clone repository
----------------

```bash
git clone https://github.com/Lvchnk88/test_task_for_oversecured.git
cd test_task_for_oversecured
```

Terraform Deployment
--------------------

1. **Run this commands to authenticate in AWS:**

```bash
export AWS_ACCESS_KEY_ID= < Your aws access key >
export AWS_SECRET_ACCESS_KEY= < Your aws secret access key >
```

2. **Update terraform/userdata.tpl file with preferences**

```bash
region            = "us-east-1"
availability_zone = "us-east-1b"
cidr_vpc          = "172.16.0.0/16"
cidr_subnet       = "172.16.10.0/24"
instance_type     = "t2.micro"
hosted_zone       = "tf-oversecured.pp.ua"
allow_ports       = ["80", "443", "22"]
```

4. **Turn On/Off SSL in terraform/variables.tf file**

```bash
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

5. **Run Terraform commands to deploy the infrastructure:**

```
cd terraform
terrafirm init
terraform plan
terraform apply
```

6. **After the deployment is complete, you will see the output with the IP address, login, and password:**

```bash
ec2_global_ips = [
  [
    "52.207.129.65",
  ],
]
login = "New_User_Name"
password = "New_User_Password"
```

License
-------

Terraform v1.5.0

This project is licensed under the [MIT License](LICENSE).


TEST DESCRIPTION
----------------
**Привіт! Завдання важке, але хто казав, шо буде легко? :)**

```
Створити акаунт на AWS
Створити двох юзерів на AWS:
Перший - ваш, через якого ви будете працювати
Другий - той, який ви дасте на перевірку (з мінімальними правами, але достатніми для перевірки тестового)
Створити EC2 інстанс (використовувати безкоштовний розмір інстанс) + відкрити до нього доступ через інтернет
На інстансі підняти NGINX, який через 80 порт віддає просту HTML сторінку
```

**Додаткові вимоги - програма Бонус+ :)** 
```
Змінити дефолтний шлях до вашої HTML-сторінки, наприклад http://*.compute.amazonaws.com/page
Обмежити доступ до інстансу тільки з певного пулу протоколів (http, https, ssh)
Обмежити доступ до інстансу тільки з певного IP і дати права нашому користувачеві додати свою IP адресу в security group самостійно.
На сторінці виводити інформацію з будь-якого публічного API (погода, курс валют, ...) з якимось періодом оновлення даних.
```

**Який вигляд має результат:**
```
Посилання на свою HTML-сторінку
Креденшели від юзера, через якого можна зайти і подивитися всередину акаунта (EC2 консоль)
```

