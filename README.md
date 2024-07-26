# kind_with_controller

A working example of a k8s cluster running in a docker container and another container controlling it via its control plane.

## kind container:
- Sets up a Kubernetes cluster
- Spins up another container called `kind-control-plane` that is used to control k8s


## python-client container:
- Controls the k8s cluster by making API calls to the `kind-control-plane` container.
- MUST be in the same network to talk to the `kind-control-plane`.


## KUBECONFIG:
- The KUBECONFIG environment variable is set to /root/.kube/config to allow the Python client to find the Kubernetes configuration.


## Dependencies:
The python-client service depends on the kind service, ensuring that the kind cluster is up and running before the Python client starts.

A docker network named `rundeck_network` MUST be created prior to running the composition. That's the network that both the `client` and the `kind-control-plane` join (configured via the [experimental](https://github.com/kubernetes-sigs/kind/pull/1538) flag).


## To get this working:

```
docker network create --driver bridge rundeck_network
docker-compose build
docker-compose up
```

## To use `kubectl`
```
# From the project root
$ export KUBECONFIG=$(pwd)/kube_dir/config
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kind-control-plane   Ready    control-plane   2m43s   v1.30.0
```

### Pod management

```
$ kubectl apply -f samples/nginx-pod.yaml
pod/nginx-pod created

$ kubectl exec -it nginx-pod -- /bin/sh
# exit
command terminated with exit code 127

$ kubectl delete pod nginx-pod
pod "nginx-pod" deleted
```

### Deployment management
```
$ kubectl apply -f samples/nginx-deployment.yaml
deployment.apps/nginx-deployment created

$ kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           33s

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-576c6b7b6-4cthc   1/1     Running   0          55s

$ kubectl delete deployment nginx-deployment
deployment.apps "nginx-deployment" deleted
```

### Service management
```
$ kubectl apply -f samples/nginx-service.yaml
service/my-service created

$ kubectl get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    5m31s
my-service   ClusterIP   10.96.217.119   <none>        8081/TCP   24s

$ kubectl delete service my-service 
service "my-service" deleted
```


## Known Issues

If you get:
```
kind           | ERROR: failed to create cluster: failed to pull image "kindest/node:v1.30.0@sha256:047357ac0cfea04663786a612ba1eaba9702bef25227a794b52890dd8bcd692e": command "docker pull kindest/node:v1.30.0@sha256:047357ac0cfea04663786a612ba1eaba9702bef25227a794b52890dd8bcd692e" failed with error: exit status 1
```

Do from your docker host machine:
```
docker pull kindest/node:v1.30.0@sha256:047357ac0cfea04663786a612ba1eaba9702bef25227a794b52890dd8bcd692e
```