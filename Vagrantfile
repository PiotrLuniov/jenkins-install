Vagrant.configure("2") do |config|

 config.vm.box = "sbeliakou/centos"
 config.vbguest.auto_update = false

 config.vm.define "jenkins" do |jenkins|
         jenkins.vm.network "private_network", ip: "192.168.56.225"
         jenkins.vm.hostname = "jenkins"
         jenkins.vm.provider "virtualbox" do |vb|
                vb.name = "jenkins"
                vb.memory = "4096"
         end
          config.vm.provision "ansible" do |ansible|
                 ansible.playbook = "provision.yml"
          end
 end

end
