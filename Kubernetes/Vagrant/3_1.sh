#! /bin/bash

#3.2 Deploying MetalLB

kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.0/manifests/metallb.yaml

cat <<EOF | kubectl apply -f -
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

# # Without MetalLB, just assigning to Master IP
# kubectl patch svc ingress-nginx -n nginx-ingress --patch '{
#   "spec": {
#     "externalIPs": [
#       "192.168.56.15"
#     ]
#   }
# }'

#3.3 Deploying Nginx Ingress Controller

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

# nginx ingress
# yum install -y git

# cd /tmp/
# git clone https://github.com/nginxinc/kubernetes-ingress.git
# cd kubernetes-ingress/deployments
# git checkout v1.5.0

# kubectl apply -f common/ns-and-sa.yaml
# kubectl apply -f common/default-server-secret.yaml
# kubectl apply -f common/nginx-config.yaml
# kubectl apply -f rbac/rbac.yaml
# kubectl apply -f deployment/nginx-ingress.yaml
# kubectl create -f service/loadbalancer.yaml
# #  With MetalLB, IP will be allocated automatically
# kubectl patch svc nginx-ingress -n nginx-ingress --patch '{
#   "spec": {
#     "type": "LoadBalancer"
#   }
# }'
# kubectl get pods --all-namespaces -l app==nginx-ingress
# kubectl get svc -n nginx-ingress

# kubernetes ingress







