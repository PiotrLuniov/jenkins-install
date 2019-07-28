#! /bin/bash
# 2.1 OS Requirements

yum install -y deltarpm
yum update -y
yum install -y epel-release wget ntp jq net-tools bind-utils moreutils

systemctl start ntpd
systemctl enable ntpd

#Disable Selinux

getenforce | grep Disabled || setenforce 0
echo "SELINUX=disabled" > /etc/sysconfig/selinux

#Disable SWAP

sed -i '/swap/d' /etc/fstab
swapoff --all

# 2.2 Configuring Docker Daemon

mkdir -p /etc/docker

# Setting CGroup Driver
 cat <<EOF > /etc/docker/daemon.json

 {
 	"exec-opts": [
 		"native.cgroupdriver=systemd"
 	]
 }
EOF

systemctl daemon-reload
systemctl restart docker

#  docker info | egrep "Cgroup Driver"

# Enable passing bridged IPv4 traffic to iptables' chains

cat <<EOF > /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# 2.3 Kubernetes Base Installation

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl kubernetes-cni

systemctl start docker

systemctl enable kubelet

# Fix for Vagrant
#Host $(hostname -I | awk '{print $2}')
sed -i "s/\(KUBELET_EXTRA_ARGS=\).*/\1--node-ip=$(hostname -I | awk '{print $2}')/" /etc/sysconfig/kubelet





