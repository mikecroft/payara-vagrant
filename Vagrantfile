# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
   config.vm.box = "ubuntu/trusty64"
   
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
   end
   
   config.vm.provision "shell", path: "provision.sh"
   
   
   # Begin cluster config
   config.vm.define "das" do |das|
      das.vm.network :forwarded_port, guest: 4848, host: 4141
      das.vm.network :forwarded_port, guest: 8080, host: 8181
      das.vm.hostname = "das"
      das.vm.network "private_network", ip: "10.0.0.100", :netmask => "255.255.0.0"
   end

   config.vm.define "node1" do |node1|
      node1.vm.hostname = "node1"
      node1.vm.network "private_network", ip: "10.0.0.101", :netmask => "255.255.0.0"
   end

   config.vm.define "node2" do |node2|
      node2.vm.hostname = "node2"
      node2.vm.network "private_network", ip: "10.0.0.102", :netmask => "255.255.0.0"
   end
   
end
