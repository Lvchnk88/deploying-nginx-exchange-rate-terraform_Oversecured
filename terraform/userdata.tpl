#!/bin/bash

# Install app
sudo apt update
sudo apt install -y nginx \
sudo apt install certbot 
sudo apt install python3-certbot-nginx

# Clone repo
git clone https://github.com/Lvchnk88/test_task_Oversecured.git

#Copy site
sudo mkdir /var/www/html/oversecured/
sudo cp -r test_task_Oversecured/nginx/oversecured/ /var/www/html/oversecured/

# Update NGINX conf
sudo sed -i 's/server_name _;/server_name oversecured.pp.ua;/' /etc/nginx/sites-available/default

# Run certbot (new domain needed)
# sudo certbot --nginx --agree-tos -d oversecured.pp.ua --register-unsafely-without-email

# Replase NGINX conf
sudo cp test_task_Oversecured/nginx/default /etc/nginx/sites-enabled/default

# Restart NGINX
sudo systemctl restart nginx