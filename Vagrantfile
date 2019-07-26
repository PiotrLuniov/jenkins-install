Vagrant.configure("2") do |config|

  config.vm.define "jenkins" do |web|

    web.vm.box = "sbeliakou/centos"
    web.vm.hostname = "jenkins"
    web.vm.network :private_network, ip: "192.168.21.5"

    web.ssh.insert_key = false

    web.vm.provider "virtualbox" do |v|

       v.customize ["modifyvm", :id, "--memory", 6000]
       v.customize ["modifyvm", :id, "--name", "jenkins"]
       v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    web.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release
      yum install -y python-pip
      yum install -y python-devel
      yum install -y java-1.8.0-openjdk
      pip install -U pip
      pip install -U ansible
    SHELL
  end
end
