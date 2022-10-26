#usr/bin/bash
sudo apt update
sudo apt install nginx -y
sudo touch vproapp
sudo echo "upstream vproapp {

 server tomcat-server:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}" >> vproapp

#sudo sed -i 's/hostname-server:8080/$TOMCATHOSTNAME:8080/g' vrpoapp
sudo mv vproapp /etc/nginx/sites-available/vproapp
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

#starting nginx service and firewall
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
printenv

































