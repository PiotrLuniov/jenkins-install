Vagrant.configure(2) do |config|
    config.vm.box = "sbeliakou/centos"
    config.vm.box_check_update = false

    config.vm.define "webserver" do |vm|
    vm.vm.network  'private_network', ip: "192.168.88.2"
    vm.vm.hostname = "webserver"
    vm.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "2048"
        vb.name = "webserver"
    end
    #config.vm.provision "ansible", type:'ansible' do |ansible|
    #    ansible.playbook = "provision.yml"
    #    ansible.extra_vars = {
    #        node_ip: "192.168.88.2",
    #    }
    #        end
      end
end
