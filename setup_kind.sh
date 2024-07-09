#!/bin/bash

echo "Setting up kind cluster"

kind delete cluster

# Create a temporary kind config file
CONFIG_FILE=$(mktemp)
cat <<EOF > "$CONFIG_FILE"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
EOF

# To allow `kind` to use the custom Docker network, I am relying on `KIND_EXPERIMENTAL_DOCKER_NETWORK`. 
# See kubernetes-sigs/kind#273 and kubernetes-sigs/kind#1538.
export KIND_EXPERIMENTAL_DOCKER_NETWORK=rundeck_network

# If you're curious about the kind config
cat "$CONFIG_FILE"

# Create a kind cluster using the temporary config file
kind create cluster --config "$CONFIG_FILE"
# Remove the temporary config file
rm "$CONFIG_FILE"

echo "Finished setting up kind cluster"

# If you're curious about the cluster config
# cat /root/.kube/config

# Wait for the client to finish its work
# Loop as long as python-client is pingable
while ping -c 1 python-client &> /dev/null; do
    echo "python-client is still reachable"
    sleep 5  
done


