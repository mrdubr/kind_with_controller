kind container:
- Sets up a Kubernetes cluster
- Spins up another container called `kind-control-plane` that is used to control k8s


python-client container:
- Controls the k8s cluster by making API calls to the `kind-control-plane` container

KUBECONFIG:
- The KUBECONFIG environment variable is set to /root/.kube/config to allow the Python client to find the Kubernetes configuration.


Dependencies:
The python-client service depends on the kind service, ensuring that the kind cluster is up and running before the Python client starts.

A docker network named `kind` MUST be created prior to running the composition. That's the network the `kind-control-plane` joins.  Furthermore, `python-client` joins it to access the `kind-control-plane`.
```
NETWORK ID     NAME                      DRIVER    SCOPE
455bbcf91bc4   kind                      bridge    local
```


To get this working:

```
docker network create --driver bridge kind
docker-compose up --build
```


