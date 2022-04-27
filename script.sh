#!/usr/bin/env bash

microk8s.enable dns dashboard
microk8s.kubectl proxy &

microk8s.enable registry

echo 'Take a 15 sec for the registery!'
sleep 15

docker build -t localhost:32000/jenkins:1.0 jenkins
docker push localhost:32000/jenkins:1.0

docker build -t localhost:32000/jenkins-slave:1.0 jenkins-slave
docker push localhost:32000/jenkins-slave:1.0

microk8s.kubectl apply -f ./jenkins/jenkins-serviceaccount.yaml
microk8s.kubectl apply -f ./jenkins/jenkins-config.yaml
microk8s.kubectl apply -f ./jenkins/jenkins-deployment.yaml

echo 'Sleep for 15 seconds the pod can start'
sleep 15

microk8s.kubectl port-forward svc/jenkins 9000:9000
