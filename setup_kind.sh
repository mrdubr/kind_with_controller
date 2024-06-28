#!/bin/bash

echo "Setting up kind cluster"

kind delete cluster

# # Create a kind cluster
kind create cluster

# If you're curious about the cluster config
# cat /root/.kube/config

echo "Finished Setting up kind cluster"

# Allows the client to do its thing
while true; do
    sleep 30  # Wait for 30 seconds before checking again
done




