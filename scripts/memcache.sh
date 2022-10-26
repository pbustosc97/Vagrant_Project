#usr/bin/bash

##Install Memcaches and dependencies
echo "///////////////INSTALLATION PROCESS/////////////"
sudo yum update -y
sudo yum install epel-release memcached -y

#Start memcached service
echo "///////////////STARTING SERVICES/////////////"
sudo systemctl start memcached 
sudo systemctl enable memcached
sudo systemctl status memcached

#Configure memcached
echo "///////////////MEMCACHED CONFIGURATION/////////////"
memcached -p 11211 -U 11111 -u memcached -d

#Set Memcached port on Firewall
echo "///////////////FIREWALL CONFIGURATION/////////////"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=11211/tcp --permanent
firewall-cmd --reload


