#!/bin/bash
# Create a kind cluster
kind create cluster

# Ensure the kubeconfig file is in the shared volume
mkdir -p /root/.kube
kind get kubeconfig > /root/.kube/config
