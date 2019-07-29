Vagrant.configure("2") do |config|
    config.vm.box = "sbeliakou/centos"
    config.vm.define "jenkins" do |js| 
	js.vm.network "private_network", ip: "192.168.56.225"
	js.vm.hostname = "jserver"
	js.vm.provision "ansible" do |ansible|
	  ansible.playbook="playbook.yml"
          #ansible.verbose="vvv"
          ansible.inventory_path = "inventory"
          ansible.limit = "jservers"
	end
    end
end
