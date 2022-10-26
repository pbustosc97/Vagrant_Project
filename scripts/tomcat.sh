#usr/bin/bash


##Pass hostnames
##DB_HOSTNAME=db-server
##MCACHE_HOSTNAME=cached-server
##RABBITMQ_HOSTNAME=rabbit-server

echo "//////////////UPDATE AND INSTALL//////////////////"
sudo yum update -y
sudo yum install epel-release git maven -y


echo "//////////////GET AND UNCOMPRESS TOMCAT//////////////////"
cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz 
sudo tar xvzf apache-tomcat-8.5.37.tar.gz


echo "//////////////CREATE TOMCAT//////////////////"
sudo useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
sudo cp -R /tmp/apache-tomcat-8.5.37/* /usr/local/tomcat8/
chown -R tomcat:tomcat /usr/local/tomcat8


echo "//////////////CONFIGURE TOMCAT SERVICE//////////////////"
sudo touch /etc/systemd/system/tomcat.service
sudo echo "[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat8
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
SuccessExitStatus=143
[Install]
WantedBy=multi-user.target" > 	/etc/systemd/system/tomcat.service


echo "//////////////START TOMCAT SERVICE//////////////////"
sudo systemctl daemon-reload
sudo systemctl start tomcat.service
sudo systemctl enable tomcat.service

echo "//////////////CONFIGURE FIREWALLD//////////////////"
sudo systemctl start firewalld 
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload


echo "//////////////CONFIGURE APPLICATION PROPERTIES//////////////////"
git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git
cd vprofile-project
sudo sed -i "s/db01/$DBHOSTNAME/g" src/main/resources/application.properties
sudo sed -i "s/mc01/$MEMCACHEHOSTNAME/g" src/main/resources/application.properties
sudo sed -i "s/rmq01/$RABBITHOSTNAME/g" src/main/resources/application.properties

echo "//////////////CREATE ARTIFCAT//////////////////"
sudo mvn install

echo "//////////////UPDATE TOMCAT ROOT DIRECTORY//////////////////"
sudo systemctl stop tomcat
sudo sleep 60
sudo rm -rf /usr/local/tomcat8/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
sudo systemctl start tomcat
sudo sleep 120

echo "//////////////CHANGE WEBAPPS OWNER//////////////////"
sudo chown -R tomcat:tomcat /usr/local/tomcat8/webapps 
sudo systemctl restart tomcat


