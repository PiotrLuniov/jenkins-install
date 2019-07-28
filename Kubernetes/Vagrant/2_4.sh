#! /bin/bash

# Master configuration

# 2.4 Cluster Initialization

# Cluster init

kubeadm init \
--pod-network-cidr 10.244.0.0/16 \
--apiserver-advertise-address 192.168.56.225 \
--token abcdef.0123456789abcdef

#Save k8s config for kubectl

mkdir -p $HOME/.kube
/bin/cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


sudo /bin/cp -f /etc/kubernetes/admin.conf /vagrant/config

export KUBECONFIG=/etc/kubernetes/admin.conf

#2.5 Deploying POD network

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
kubectl patch daemonsets kube-flannel-ds-amd64 -n kube-system --patch='{
  "spec":{
    "template":{
      "spec":{
        "containers":[
          {
            "name": "kube-flannel",
            "args": [
              "--ip-masq",
              "--kube-subnet-mgr",
              "--iface=eth1"
            ]
          }
        ]
      }
    }
  }
}'

kubectl get daemonsets -n kube-system kube-flannel-ds-amd64
kubectl get nodes | grep master

# Remove master isolation

#kubectl taint nodes --all node-role.kubernetes.io/master-