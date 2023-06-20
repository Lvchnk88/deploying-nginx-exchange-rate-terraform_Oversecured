#!/bin/bash
sudo apt update -y && \
sudo apt install -y nginx
sudo apt install -y certbot python3-certbot-nginx
sudo mkdir -d /var/www/http/oversecured
git clone https://github.com/Lvchnk88/test_task_Oversecured.git

sudo systemctl enable nginx.system
cp nginx/default /etc/nginx/site-enable/
cp nginx/oversecured/* /var/www/http/oversecured/
