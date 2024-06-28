#!/bin/bash

echo "Setting up kind cluster"

kind delete cluster

# # Create a kind cluster
kind create cluster

# If you're curious about the cluster config
# cat /root/.kube/config

echo "Finished Setting up kind cluster"

# Wait for the client to finish
# Loop as long as python-client is pingable
while ping -c 1 python-client &> /dev/null; do
    echo "python-client is still reachable"
    sleep 5  
done


