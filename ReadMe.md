# Jenkins on K8s

## Jenkins on microk8s:

#### Deploy jenkins on microk8s

1. we want to see what we are doing, so spin up the dashboard
```
microk8s.enable dns dashboard
microk8s.kubectl proxy
```
now serving to http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy

2. We trying to push or own docker images so we need a registry
```
microk8s.enable registry
```

3. Build de images en push them to the registry:
```
# Build images en push to registry of microk8s
docker pull jenkins/jenkins
docker image tag jenkins/jenkins:latest localhost:32000/jenkins:1.0
docker push localhost:32000/jenkins:1.0

docker build -t localhost:32000/jenkins-slave:1.0 jenkins-slave
docker push localhost:32000/jenkins-slave:1.0
```


4. spin up jenkins deployment:
```
microk8s.kubectl apply -f ./jenkins/jenkins-serviceaccount.yaml
microk8s.kubectl apply -f ./jenkins/jenkins-config.yaml
microk8s.kubectl apply -f ./jenkins/jenkins-deployment.yaml

```

After deploying on k8s, port-forward jenkins to your system.
```
microk8s.kubectl port-forward svc/jenkins 9000
```
With http://localhost:9000 you could connect to jenkins


## search for ip adresses for configuration

Setup k8s on jenkins in `configure system`
```
# get service ip van kubernetes
microk8s.kubectl cluster-info | grep master #e.g. local-ip:8080

# search for the ip from pod `jenkins`
microk8s.kubectl get pods | grep jenkins #e.g. jenkins-5fdbf5d7c5-dj2rq
microk8s. kubectl describe pod jenkins-5fdbf5d7c5-dj2rq #e.g. 10.1.1.117:8080
```

add new cloud:

다 좋은데 잘 안되길래 몇 가지 수정했습니다.
1. jenkins 는 더 이상 제공되지 않는 image라 jenkins/jenkins로 교체함
2. jenkins 이미지 빌드를 해보면 아마 SSL 관련 오류가 납니다.
   빌드를 하지 않고, 최신 버전 jenkins에 tag만 달아서 microk8s의 registry로 push 했습니다.
3. config, deploy, service 의 apiVersion이 변경되었습니다. beta 딱지를 떼어드렸습니다.

에러가 없기를 기원합니다.

microk8s.kubectl scale deploy jenkins --replicas=0 && microk8s.kubectl scale deploy jenkins --replicas=1







