#!/bin/bash

echo "Setting up kind cluster"

kind delete cluster

# Create a temporary kind config file in the SAME network as the client container
CONFIG_FILE=$(mktemp)
cat <<EOF > "$CONFIG_FILE"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
EOF

# If you're curious about the kind config
cat "$CONFIG_FILE"

# Create a kind cluster using the temporary config file
kind create cluster --config "$CONFIG_FILE"
# Remove the temporary config file
rm "$CONFIG_FILE"

echo "Finished setting up kind cluster"

# If you're curious about the cluster config
# cat /root/.kube/config

echo "Finished Setting up kind cluster"

# Wait for the client to finish
# Loop as long as python-client is pingable
while ping -c 1 python-client &> /dev/null; do
    echo "python-client is still reachable"
    sleep 5  
done


