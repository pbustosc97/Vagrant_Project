#Vagrant VMs Configuration

#Set Hostname Variables
$DBHOSTNAME = "db-server"
$MEMCACHEHOSTNAME = "cached-server"
$RABBITHOSTNAME = "rabbit-server"
$TOMCATHOSTNAME = "tomcat-server"
$NGINXHOSTNAME = "nginx-server"

#Vagrantfile Configuration Block
Vagrant.configure("2") do |config|
config.hostmanager.enabled = true
config.hostmanager.manage_host = true

#Provision to pass the HOSTNAMES as Env Variables
config.vm.provision "set_vars", type: "shell", 
  inline:
"cd /vagrant/scripts
   echo ' #$DBHOSTNAME'
  ./set_var.sh #$DBHOSTNAME #$MEMCACHEHOSTNAME #$RABBITHOSTNAME #$TOMCATHOSTNAME #$NGINXHOSTNAME
"
##DB VM Block
config.vm.define "#$DBHOSTNAME" do |db|
db.vm.box = "geerlingguy/centos7"
db.vm.hostname = $DBHOSTNAME
db.vm.network "private_network", ip: "192.168.56.15"
db.vm.provision "shell", path: "scripts/mysql.sh"

end
##MEMCACHE VM Block
config.vm.define "#$MEMCACHEHOSTNAME" do |mc|
mc.vm.box = "geerlingguy/centos7"
mc.vm.hostname = $MEMCACHEHOSTNAME
mc.vm.network "private_network", ip: "192.168.56.14"
mc.vm.provision "shell", path: "scripts/memcache.sh"

end

##RABBIT VM Block
config.vm.define "#$RABBITHOSTNAME" do |rb|
rb.vm.box = "geerlingguy/centos7"
rb.vm.hostname = $RABBITHOSTNAME
rb.vm.network "private_network", ip: "192.168.56.13"
rb.vm.provision "shell", path: "scripts/rabbit.sh"

end

##TOMCAT VM Block
config.vm.define "#$TOMCATHOSTNAME" do |tc|
tc.vm.box = "geerlingguy/centos7"
tc.vm.hostname = $TOMCATHOSTNAME
tc.vm.network "private_network", ip: "192.168.56.12"
tc.vm.provision "shell", path: "scripts/tomcat.sh"

end

##NGINX VM Block
config.vm.define "#$NGINXHOSTNAME" do |nx|
nx.vm.box = "ubuntu/xenial64"
nx.vm.hostname = $NGINXHOSTNAME
nx.vm.network "private_network", ip: "192.168.56.11"
nx.vm.provision "shell", path: "scripts/nginx.sh"

end

end
