
kubectl create namespace jenkins

kubectl apply -f jenkins-volume.yml --namespace=jenkins
kubectl apply -f jenkins-deployment.yml --namespace=jenkins
kubectl apply -f jenkins-service.yml --namespace=jenkins
kubectl apply -f jenkins-ingress.yml --namespace=jenkins

kubectl get pods -A


