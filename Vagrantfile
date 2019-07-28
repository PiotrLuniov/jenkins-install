Vagrant.configure("2") do |config|
  config.vm.box = "sbeliakou/centos"

 #create a nod name webserver
 config.vm.define "webserver" do |webserver|
   webserver.vm.box = "sbeliakou/centos"
   webserver.vm.network :private_network, ip: "192.168.200.200"
   webserver.vm.hostname = "jenkins"
   webserver.vm.provider "virtualbox" do |vb|
   webserver.vm.provision "ansible" do |ansible|
       ansible.playbook = "playbook.yml"
       ansible.inventory_path = "inventory"
       ansible.limit = "all"
       ansible.verbose = "v"
     end

     vb.memory = 1024
     vb.name = "jenkins_day1"
   end 
end


end
