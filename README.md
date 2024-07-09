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

A docker network named `kind` MUST be created prior to running the composition. That's the network the `kind-control-plane` joins and it's [NOT configurable](https://github.com/kubernetes-sigs/kind/issues/273).
```
NETWORK ID     NAME                      DRIVER    SCOPE
455bbcf91bc4   kind                      bridge    local
```


## To get this working:

```
docker network create --driver bridge kind
docker-compose build
docker-compose up
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