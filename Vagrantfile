Vagrant.configure(2) do |config|
    config.vm.define "jnks-master", primary: true do |app|
        app.vm.box = "sbeliakou/centos"
        app.vm.box_check_update = false
        app.vm.hostname = "jnks-master"
        app.vm.network "private_network", ip: "172.20.32.10"
        app.vm.define "master"
        app.vm.provider "virtualbox" do |vb|
            vb.gui = false
            vb.memory = "2048"
            vb.name = "jnks-master"
        end
    config.vm.provision "ansible", type:'ansible' do |ansible|
        ansible.playbook = "jenkins-up.yml"
        ansible.extra_vars = {
            node_ip: "172.20.32.10",
        }
        end
    end
end
