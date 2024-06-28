import time
from kubernetes import client, config
import yaml


def main():

    print("Loading configs")

    # Loop until the configuration contains the ['clusters'][0]['cluster']['server'] key
    while True:
        try:
            # Load the kubeconfig file
            with open(config.kube_config.KUBE_CONFIG_DEFAULT_LOCATION, 'r') as kube_file:
                    kube_config_dict = yaml.safe_load(kube_file)

            kube_config_dict['clusters'][0]['cluster']['server'] = 'blah'
            
            break
        except Exception as e:
            print("Waiting for the configuration to be ready")
            time.sleep(2)


    # Load the existing kubeconfig file into a dictionary
    with open(config.kube_config.KUBE_CONFIG_DEFAULT_LOCATION, 'r') as kube_file:
        kube_config_dict = yaml.safe_load(kube_file)

    # Modify the server URL to the control plane service
    kube_config_dict['clusters'][0]['cluster']['server'] = 'https://kind-control-plane:6443'

    # Load the modified configuration
    config.load_kube_config_from_dict(kube_config_dict)

    print("Getting the client")

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


