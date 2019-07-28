#! /bin/bash

#2.4 Join cluster

kubeadm join 192.168.56.225:6443 --token abcdef.0123456789abcdef --discovery-token-unsafe-skip-ca-verification
