
# Public IP
output "ec2_global_ips" {
  value = ["${aws_instance.oversecured_test_vm.*.public_ip}"]
}

### Creds
output "login" {
  value = aws_iam_user.oversecured_user.name
}

# Password
output "password" {
  value = aws_iam_user_login_profile.oversecured_user.password
}

# Access key
# output "secret_access_key" {
#   value     = aws_iam_access_key.oversecured_user.id
# }