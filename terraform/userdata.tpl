
#!/bin/bash

# Install app
sudo apt update
sudo apt install -y nginx

# Clone repo
git clone https://github.com/Lvchnk88/test_task_Oversecured.git

# Copy site
sudo mkdir /var/www/html/oversecured/
sudo cp -r test_task_Oversecured/nginx/oversecured/ /var/www/html/

%{ if domain_name != null }
# Update NGINX conf
sudo sed -i 's/server_name _;/server_name ${domain_name};/' /etc/nginx/sites-available/default

%{ if enable_nginx_ssl }
# Install certbot (new domain needed)
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx --agree-tos -d ${domain_name} --register-unsafely-without-email
sudo cp test_task_Oversecured/nginx/default /etc/nginx/sites-enabled/default_for_https

%{ endif }
%{ endif }

# Replase NGINX conf
sudo cp test_task_Oversecured/nginx/default /etc/nginx/sites-enabled/default

# Restart NGINX
sudo systemctl restart nginx