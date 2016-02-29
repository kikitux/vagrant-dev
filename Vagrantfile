# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "alvaro/jessie"
  config.vm.hostname = "jessie-go16"
  config.vm.provision "bootstrap", type: "shell", path: ".dev/vagrant/provision.sh" , privileged: "true"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/vagrant/go/src/bitbucket.org/humense/frame-server"
end
