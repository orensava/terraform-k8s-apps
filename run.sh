#!/bin/bash

set -e

echo "📦 Running 'terraform init'..."
terraform init -upgrade

echo "🚀 Creating Kind cluster and writing kubeconfig..."
terraform apply -target=kind_cluster.this -auto-approve
terraform apply -target=local_file.kubeconfig -auto-approve
terraform apply -target=null_resource.wait_for_kubeconfig -auto-approve

echo "📡 Applying Kubernetes resources (apps)..."
terraform apply -auto-approve

echo "🔁 Waiting for pods to be ready..."
./port_forward.sh
