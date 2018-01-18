# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
   config.vm.box = "ubuntu/xenial64"
   
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
   end
   
   config.vm.provision "shell", path: "provision.sh"
   config.vm.provision "shell", inline: 'sudo printf "\n10.0.0.109 das das" >> /etc/hosts'
   config.vm.provision "shell", inline: 'sudo printf "\n10.0.0.101 node1 node1" >> /etc/hosts'
   config.vm.provision "shell", inline: 'sudo printf "\n10.0.0.102 node2 node2" >> /etc/hosts'
   
   
   # Begin cluster config
   config.vm.define "das" do |das|
      das.vm.network :forwarded_port, guest: 4848, host: 9048
      das.vm.network :forwarded_port, guest: 8080, host: 9080
      das.vm.hostname = "das"
      das.vm.network "private_network", ip: "10.0.0.109", :netmask => "255.255.0.0"
   
      das.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      das.vm.provision "shell", path: "das.sh"
   end

   config.vm.define "node1" do |node1|
      node1.vm.hostname = "node1"
      node1.vm.network :forwarded_port, guest: 8080, host: 1080
      node1.vm.network "private_network", ip: "10.0.0.101", :netmask => "255.255.0.0"
      node1.vm.provision "shell", path: "node1.sh"
   end

   config.vm.define "node2" do |node2|
      node2.vm.hostname = "node2"
      node2.vm.network :forwarded_port, guest: 8080, host: 2080
      node2.vm.network "private_network", ip: "10.0.0.102", :netmask => "255.255.0.0"
      node2.vm.provision "shell", path: "node2.sh"
   end
   
end
