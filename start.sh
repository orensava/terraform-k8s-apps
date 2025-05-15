#!/bin/bash

set -e

CLUSTER_NAME="terraform-cluster"

echo "Checking if Kind cluster '$CLUSTER_NAME' exists..."
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "🚀 Creating Kind cluster..."
  kind create cluster --name "$CLUSTER_NAME"
else
  echo "Kind cluster '$CLUSTER_NAME' already exists"
fi

echo "Waiting for Kubernetes node to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

echo "Running Terraform..."
terraform init
terraform apply

echo "Starting port-forwarding in background..."

# Forward app1 to localhost:8080
kubectl port-forward svc/app1-svc 8080:5678 > /dev/null 2>&1 &
APP1_PID=$!

# Forward app2 to localhost:8081
kubectl port-forward svc/app2-svc 8081:5678 > /dev/null 2>&1 &
APP2_PID=$!

echo "🌍 Access your applications here:"
echo " - http://localhost:8080 (app1)"
echo " - http://localhost:8081 (app2)"
echo ""
echo "Press Ctrl+C to stop port-forwarding."

wait $APP1_PID $APP2_PID
