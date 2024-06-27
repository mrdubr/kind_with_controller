import time
import requests
from kubernetes import client, config

def main():
    # Wait for the kind cluster to be ready
    time.sleep(30)

    # Load kube config
    config.load_kube_config()

    # Create a Kubernetes API client
    v1 = client.CoreV1Api()

    # List all namespaces
    print("Listing namespaces:")
    namespaces = v1.list_namespace()
    for ns in namespaces.items:
        print(ns.metadata.name)

    # Example of creating a namespace
    namespace = client.V1Namespace(
        metadata=client.V1ObjectMeta(name="example-namespace")
    )
    v1.create_namespace(body=namespace)
    print("Namespace 'example-namespace' created")

if __name__ == "__main__":
    main()
