#!/bin/bash
kubectl create ns jenkins
kubectl config set-context --current --namespace=jenkins
cat << EOF >  persistentVolume.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: localvolume-pv
spec:
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - jenkins
          - node1
          - node2
  capacity: 
    storage: 5Gi
  accessModes: 
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /tmp
EOF
kubectl apply -f persistentVolume.yml 
cat << EOF >  persistentVolumeClsim.yml

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: localvolume-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
EOF
kubectl apply -f persistentVolumeClsim.yml 
cat << EOF > jenkins-deployment.yaml
apiVersion: extensions/v1beta1 
kind: Deployment
metadata:
  name: jenkins-deployment
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins
        image: jenkins:2.32.2
        ports:
        - containerPort: 8080

EOF

      #   volumeMounts:
      #   - name: jenkins-home
      #     mountPath: /var/jenkins_home
      # volumes:
      # - name: jenkins-home
      #   persistentVolumeClaim:
      #     claimName: localvolume-pvc

kubectl apply -f jenkins-deployment.yaml 
cat << EOF > jenkins-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins
spec:
  type: LoadBalancer
  ports:
    - port: 8080
      targetPort: 8080
      name: jenkins-port
  selector:
    app: jenkins
EOF
kubectl apply -f jenkins-service.yaml 

cat << EOF > ingress_jenkins.yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /

spec:
  rules:
  - host: jenkins.kube
    http:
      paths:
      - path: /
        backend:
          serviceName: jenkins
          servicePort: jenkins-port
EOF
kubectl apply -f ingress_jenkins.yml 