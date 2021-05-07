#!/bin/bash
#Script to install HTTPD on AWS EC2(Amazon Linux) Instance and Access Instance metadata via html page
sudo yum install -y httpd #Install httpd server 
sudo systemctl start httpd #Start httpd server
sudo systemctl enable httpd #Enable httpd to be started after every restart
aws s3 cp s3://sr-s3-exercise/sample.html /var/www/html/sample.html
