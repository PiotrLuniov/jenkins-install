# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "sbeliakou/centos"
    jenkins.vm.box_check_update = false
    jenkins.vm.network :private_network, ip: "172.64.16.31"
    jenkins.ssh.insert_key = false
    jenkins.vm.hostname = "centos-jenkins"

    jenkins.vm.provider "virtualbox" do |vb|
      vb.name = "centos-jenkins"
      vb.memory = "2048"
    end
    
    jenkins.vm.provision "shell", inline: "yum update -y"
    # jenkins.playbook = "./ansible-provision/playbook.yml"
  end

end
