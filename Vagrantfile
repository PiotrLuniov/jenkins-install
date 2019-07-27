Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box = "sbeliakou/centos"

    config.vm.define "jenkins" do |machine|
        machine.vm.hostname = "jenkins"
        machine.vm.network "private_network", ip: "192.168.56.225"

        machine.vm.provider "virtualbox" do |vb|
            vb.name = "Jenkins-Machine"
            vb.memory = "2048"
        end

        machine.vm.provision "ansible" do |ansible|
            #ansible.playbook = "ansible/provision.yml"
            ansible.playbook = "ansible/provision_kubernetes.yml"
            ansible.limit = "all"
            ansible.inventory_path = "inventory"
            ansible.verbose = "v"
        end
    end
end
