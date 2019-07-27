#!/usr/bin/env bash

## Cluster initialization
#Cluster init
kubeadm init \
--pod-network-cidr 10.244.0.0/16 \
--apiserver-advertise-address 192.168.56.225 \
--token abcdef.0123456789abcdef

kubectl cluster-info
kubectl get nodes

#openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
#  openssl dgst -sha256 -hex | sed 's/^.* //' \
#  > /vagrant/discovery-token-ca-cert-hash.txt

cp -f /etc/kubernetes/admin.conf /vagrant/

#Save k8s config for kubectl
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#Save k8s config for vagrant
mkdir -p /home/vagrant/.kube
cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# #Save k8s config for localhost
#  cp -f admin.conf $HOME/.kube/config


#### Kubernetes Add-ons
### Deploying POD network Flannel CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
# kubectl apply -f /vagrant/flannel.yml
kubectl patch daemonsets kube-flannel-ds-amd64 -n kube-system --patch='{"spec":{"template":{"spec":{"containers":[{"name": "kube-flannel","args": ["--ip-masq","--kube-subnet-mgr","--iface=eth1"]}]}}}}'
#Get info
#kubectl get daemonsets -n kube-system kube-flannel-ds-amd64
#kubectl get nodes | grep master


##Single-machine Kubernetes cluster for development
## Must be after network !!!
kubectl taint nodes --all node-role.kubernetes.io/master-


## Deploying MetalLB
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.0/manifests/metallb.yaml

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.56.240/28
EOF

kubectl get pods -n metallb-system


##  Deploying Ingress Controller Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
##kubectl patch svc -n ingress-nginx ingress-nginx --patch '{"spec": {"type": "LoadBalancer"}}'
#sleep 30s


#Access the Live Activity Monitoring Dashboard / Stub_status Page
#  kubectl port-forward $(kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx | \
#   cut -d' ' -f4) 8080:8080 --namespace=nginx-ingress


## Kubernetes Metrics Server
#cd /tmp/
#git clone https://github.com/kubernetes-incubator/metrics-server.git
#kubectl create -f  metrics-server/deploy/1.8+/
#kubectl patch deployment/metrics-server -n kube-system --patch '{"spec": {"template": {"spec": {"containers": [{"name": "metrics-server", "command":["/metrics-server", "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname", "--kubelet-insecure-tls"]}]}}}}'


#Install bash-completion
yum -y install bash-completion
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc
echo "source <(kubectl completion bash)" >>~/.bashrc
kubectl completion bash >/etc/bash_completion.d/kubectl
#Installation With Helm
# helm install --name metallb stable/metallb

#### Helm
#cd /tmp
#wget -q https://get.helm.sh/helm-v2.14.2-linux-amd64.tar.gz
#tar -zxvf helm-v2.14.2-linux-amd64.tar.gz
#cp -f linux-amd64/helm /usr/bin/helm
#helm init
#kubectl get pods --namespace kube-system