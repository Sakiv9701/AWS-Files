#Script to install HTTPD on AWS EC2(Amazon Linux) Instance and Access Instance metadata via html page
sudo yum install -y httpd #Install httpd server 
sudo systemctl start httpd #Start httpd server
sudo systemctl enable httpd #Enable httpd to be started after every restart
INSTANCEID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) #Curl the url for InstanceID and store it in a shell variable
sudo echo "<HEAD>Instance ID of this Machie is $INSTANCEID</HEAD>" | sudo tee  /var/www/html/a.html #Create and write to an HTML file
