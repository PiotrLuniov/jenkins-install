#!/bin/bash
kubectl create ns jenkins-volume
kubectl config set-context --current --namespace=jenkins-volume
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
    storage: 1Gi
  accessModes: 
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /tmp
EOF
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
    storage: 1Gi
  accessModes: 
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /tmp
EOF
kubectl apply -f persistentVolume.yml 
cat << EOF >  persistentVolumeClaim.yml

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
      storage: 500m
EOF
kubectl apply -f persistentVolumeClaim.yml 
cat << EOF > jenkins-deployment-volume.yaml
apiVersion: extensions/v1beta1 
kind: Deployment
metadata:
  name: jenkins-deployment-volume
  labels:
    app: jenkins-volume
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins-volume
  template:
    metadata:
      labels:
        app: jenkins-volume
    spec:
      containers:
      - name: jenkins-volume
        image: jenkins:2.32.2
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: jenkins-home
          mountPath: /var/jenkins_home
      volumes:
      - name: jenkins-home
        persistentVolumeClaim:
          claimName: localvolume-pvc

EOF

      

kubectl apply -f jenkins-deployment-volume.yaml 
cat << EOF > jenkins-service-volume.yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-volume
spec:
  type: LoadBalancer
  ports:
    - port: 8081
      targetPort: 8080
      name: jenkins-port-volume
  selector:
    app: jenkins-volume
EOF
kubectl apply -f jenkins-service-volume.yaml 

cat << EOF > ingress-jenkins-volume.yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins-ingress-volume
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /

spec:
  rules:
  - host: jenkins.kube.volum
    http:
      paths:
      - path: /
        backend:
          serviceName: jenkins-volume
          servicePort: 8081
EOF
kubectl apply -f ingress-jenkins-volume.yml 