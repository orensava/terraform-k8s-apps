# Automating Infrastructure with Terraform

This project provisions a local Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) and deploys two scalable applications using Terraform and the Kubernetes provider.

## Features

- Cluster creation using Terraform (with Kind)
- Scalable deployment using `for_each` and modules
- Public image: `stefanprodan/podinfo:6.5.3`
- Readiness and liveness probes
- Minimal hardcoded values
- Clean `.gitignore`
- Port forwarding to access the services locally

## Prerequisites

- Terraform
- `kubectl`
- `kind`
- Podman or Docker installed and configured

## Usage

1. Make the script executable:

```bash
chmod +x port_forward.sh
chmod +x start.sh

2. Apply the infrastructure and start port forwarding:

 ./start.sh

 
