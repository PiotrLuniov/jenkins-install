Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  ip=["192.168.68.92", "192.168.68.93", "192.168.68.94" ]
  box="sbeliakou/centos"
  servers=[
  {
    :hostname => "node1",
    :ip => ip[1],
    :box => "sbeliakou/centos",
    :ram => 2048,
    :cpu => 2,
  },
  {
    :hostname => "node2",
    :ip => ip[2],
    :box => "sbeliakou/centos",
    :ram => 2048,
    :cpu => 2,
  }
]
master=[
  {
    :hostname => "jenkins",
    :ip => ip[0],
    :box => "sbeliakou/centos",
    :ram => 2048,
    :cpu => 2,
  }]

    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]] 
            end
        end
    end
master.each do |machine|
    config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]]         
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "Ansible/provision.yml"
                #ansible.playbook = "k8sAnsible/playbook.yml"
                ansible.limit = "all"
                ansible.inventory = "inventory"
                ansible.verbose = "vv"
            end        
    end
end
end
