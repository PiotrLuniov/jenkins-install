Vagrant.configure(2) do |config|
  config.vm.define "jenkins", primary: true do |app|
    app.vm.box = "sbeliakou/centos"
    app.vm.box_check_update = false
    app.vm.hostname = "jenkins"
    app.vm.network "private_network", ip: "192.168.0.50"
    app.vm.define "jenkins"
    app.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
      vb.name = "jenkins"
    end
    app.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
