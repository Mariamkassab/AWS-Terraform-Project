#!/bin/bash
apt-get update
apt-get -y install apache2
systemctl start apache2
systemctl enable apache2
echo "Hello World from ITI !" > /var/www/html/index.html




# "sudo apt update -y",
#      "sudo apt install -y nginx",
#      "sudo systemctl start nginx",
#      "sudo systemctl enable nginx",
#      "sudo unlink /etc/nginx/sites-enabled/default",
#      "sudo sh -c 'echo \"server { \n listen 80; \n location / { \n proxy_pass http://${var.lb_dns}; \n } \n }\" > /etc/nginx/sites-available/#reverse-proxy.conf'",
 #     "sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf",
 #     "sudo systemctl restart nginx"
 #   ]    
