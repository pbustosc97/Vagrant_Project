#usr/bin/bash/
#Script for MySQL Configuration

#Update and install MySQL Dependencies
echo "/////////// MYSQL and DEPENDENCIES INSTALLATION ///////////////"
sudo yum update -y
sudo yum install epel-release git mariadb-server -y

#Start and enable MySQL Service
echo "/////////////// STARTING MARIADB SERVICE ////////////////////"
sudo systemctl start mariadb
sudo systemctl enable mariadb

DB_USER_PASSWD='admin123'


##Configuration of MariaDB
echo "/////////////// MariaDB CONFIGURATION ////////////////////"
cd /tmp/
git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git
sudo mysqladmin -u root password "$DB_USER_PASSWD"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "UPDATE mysql.user SET Password=PASSWORD('$DB_USER_PASSWD') WHERE User='root'"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1')"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "create database accounts"
sudo mysql -u root -p"$DB_USER_PASSWD" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DB_USER_PASSWD" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DB_USER_PASSWD" -e "FLUSH PRIVILEGES"
echo "/////////////////CHECK ACCOUNTS DB//////////////////"
sudo mysql -u root -p"$DB_USER_PASSWD" accounts -e "SHOW TABLES"

echo "/////////////////RESTARTING MariaDB SERVICE//////////////"
sudo systemctl restart mariadb

echo "/////////////////FIREWALL CONFIGURATION//////////////"
##Enabling DB port
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl restart mariadb
