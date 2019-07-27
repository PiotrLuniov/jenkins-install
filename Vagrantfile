
Vagrant.configure("2") do |config|

  config.vm.define "master" do |master|
    master.vm.box = "sbeliakou/centos"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip:"192.168.56.225"
    master.vm.provision "shell", inline: <<-SHELL
      yum install -y yum-utils jq net-tools
    SHELL
    master.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision_jenkins.yml"
    #master.vm.provision "shell", path:"script_master.sh"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "master"
      vb.memory = "6144"
    end
    end
  end
end

#(1..3).each do |i|
#  config.vm.define "node-#{i}" do |node|
#    node.vm.provision "shell",
#      inline: "echo hello from node #{i}"
#  end
#end
