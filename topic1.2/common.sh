#!/bin/bash

# OS Requirements
yum -y install deltarpm
yum -y update
yum -y install epel-release wget ntp jq net-tools bind-utils moreutils

systemctl start ntpd
systemctl enable ntpd

# Disabling SELinux
getenforce | grep Disabled || setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Disabling SWAP
sed -i '/swap/d' /etc/fstab
swapoff --all


##Configuring Docker Daemon
yum install -y yum-utils device-mapper-persistent-data lvm2 git
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install -y docker-ce-18.09.8-3.el7.x86_64 docker-ce-cli containerd.io
yum install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

systemctl start docker
systemctl enable docker

# # Setting CGroup Driver
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
    "exec-opts": [
        "native.cgroupdriver=systemd"
	],
	"log-driver": "json-file",
    "log-opts": {
    "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
    "overlay2.override_kernel_check=true"
    ]
}
EOF

#cat <<EOF > /etc/docker/daemon.json
#{
#	"exec-opts": [
#        "native.cgroupdriver=systemd"
#	]
#}
#EOF

systemctl daemon-reload
systemctl restart docker
# docker info | egrep "CGroup Driver"


## CRI-O as CRI runtime
##modprobe overlay
##modprobe br_netfilter
cat <<EOF > /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

## Install prerequisites
##yum-config-manager --add-repo=https://cbs.centos.org/repos/paas7-crio-311-candidate/x86_64/os/
## Install CRI-O
##yum install --nogpgcheck cri-o


# Kubernetes Base Installation
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum -y install kubelet kubeadm kubectl # kebernetes-cni
#systemctl start docker
systemctl enable kubelet
systemctl restart docker


# Fix for Vagrant
ip="192.168.56.225"
sed -i "s/\(KUBELET_EXTRA_ARGS=\).*/\1--node-ip=$ip/" /etc/sysconfig/kubelet

#ip=$(hostname -I | cut -d' ' -f2)
#echo $ip
#sed -i "s/\(KUBELET_EXTRA_ARGS=\).*/\1--node-ip=$ip/" /etc/sysconfig/kubelet





