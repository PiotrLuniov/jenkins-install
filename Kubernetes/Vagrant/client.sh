#! /bin/bash


# 4.1 Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl


chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version

# 4.2 Configuring kubectl Access to Cluster

chown student:student config
mkdir -p $HOME/.kube
mv config $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> ~/.bashrc

kubectl cluster-info


# 4.3 Configure kubectl bash completion 

sudo yum install -y bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
