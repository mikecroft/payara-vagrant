# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
   config.vm.box = "ubuntu/trusty64"
   
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
   end
   
   config.vm.provision "shell", path: "provision.sh"
   config.vm.network :forwarded_port, guest: 4848, host: 4849
   config.vm.network :forwarded_port, guest: 8080, host: 8081
   
   
   # Begin cluster config
   config.vm.network "private_network", ip: "10.0.1.1"

   
end
