#!/bin/bash
apt-get update
apt-get -y install apache2
systemctl start apache2
systemctl enable apache2
a2enmod proxy
a2enmod proxy_http
echo 'ProxyPass "/" "http://internal-private-lb-1700357556.eu-north-1.elb.amazonaws.com/"
ProxyPassReverse "/" "http://internal-private-lb-1700357556.eu-north-1.elb.amazonaws.com/" ' | tee -a /etc/apache2/apache2.conf
systemctl restart apache2


