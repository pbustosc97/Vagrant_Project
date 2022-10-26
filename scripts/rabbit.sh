#usr/bin/bash

##Update and install dependencies
echo "///////////////INSTALLATION PROCESS/////////////"
sudo yum update -y
sudo install epel-release wget -y

##Download dependencies
echo "///////////////DOWNLOAD PROCESS/////////////"
cd /tmp/
wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
sudo rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
sudo yum install erlang socat -y



##Get and execute Rabbitmq 
echo "///////////////EXECUTION PROCESS/////////////"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash 
sudo yum install rabbitmq-server -y


##Start Rabbitmq-server
echo "///////////////INITIALIZATION RABBITMQ-SERVER PROCESS/////////////"
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server


##Configure Rabbitmq
echo "///////////////CONFIGURATION PROCESS/////////////"
sudo sh -c 'echo "[{rabbit,[{loopback_users,[]}]}]." > /etc/rabbitmq/rabbitmq.config'

##Create test user on rabbitmq
echo "///////////////USER CREATION PROCESS/////////////"
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrador

##Restart rabbitmq-server
sudo systemctl restart rabbitmq-server


