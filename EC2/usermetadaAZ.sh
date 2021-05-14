#!/bin/bash
#Script to install HTTPD on AWS EC2(Amazon Linux) Instance and Access Instance metadata via html page
sudo yum install -y httpd #Install httpd server 
sudo systemctl start httpd #Start httpd server
sudo systemctl enable httpd #Enable httpd to be started after every restart
AZID=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone) #Curl the url for Availability Zone and store it in a shell variable
sudo echo "<HEAD><center><h1>Instance ID of this Machie is $AZID</h1><center></HEAD>" | sudo tee  /var/www/html/a.html #Create and write to an HTML file
