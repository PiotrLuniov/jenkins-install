
Vagrant.configure("2") do |config|

	config.vm.define "master" do |master|
  	master.vm.box = "sbeliakou/centos"
  	master.vm.hostname = "master"
  	master.vm.network "private_network", ip: "192.168.56.225"

  	master.vm.provider "virtualbox" do |vb|
  		vb.name = "master"
  		vb.memory = "3096"
  	end
  end
  
  # config.vm.define "worker" do |worker|
  # 	worker.vm.box = "sbeliakou/centos"
  # 	worker.vm.hostname = "worker"
  # 	worker.vm.network "private_network", ip: "192.168.56.226"

  # 	worker.vm.provider "virtualbox" do |vb|
  # 		vb.name = "worker"
  # 		vb.memory = "4096"
  # 	end
  # end

end
