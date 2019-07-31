Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  ip=["192.168.68.92", "192.168.68.93", "192.168.68.94" ]
  box="sbeliakou/centos"
  servers=[
  {
    :hostname => "jenkins",
    :ip => ip[0],
    :box => "sbeliakou/centos",
    :ram => 3068,
    :cpu => 2,
  },
  {
    :hostname => "node1",
    :ip => ip[1],
    :box => "sbeliakou/centos",
    :ram => 2068,
    :cpu => 2,
  },
  {
    :hostname => "node2",
    :ip => ip[2],
    :box => "sbeliakou/centos",
    :ram => 4068,
    :cpu => 2,
  }
]
k = 0
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      node.vm.network "private_network", ip: machine[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]] 
          end
      if k == 2
        node.vm.provision "ansible" do |ansible|
        #ansible.playbook = "Ansible/provision.yml"
        ansible.playbook = "k8sAnsible/playbook.yml"
        ansible.limit = "all"
        ansible.inventory_path = "inventory"
        ##ansible.verbose = "v"
          end 
      else
        k += 1
      end 
      end              
    end
end
