#!/bin/bash

set -e

function wait_for_pods_ready() {
  app_name=$1
  echo "Waiting for pods of ${app_name} to be ready..."
  kubectl wait --for=condition=ready pod -l app=${app_name} --timeout=60s >/dev/null
  echo "✅ ${app_name} pods are ready."
}

wait_for_pods_ready "app1"
wait_for_pods_ready "app2"

echo "Starting port-forwarding..."

kubectl port-forward svc/app1-svc 8081:9898 > app1-port-forward.log 2>&1 &
PF1_PID=$!
sleep 2
if ! ps -p $PF1_PID > /dev/null; then
  echo "❌ Failed to start port-forward for app1-svc. See app1-port-forward.log"
else
  echo "✔ app1-svc -> http://localhost:8081 (PID=$PF1_PID)"
fi

kubectl port-forward svc/app2-svc 8082:9898 > app2-port-forward.log 2>&1 &
PF2_PID=$!
sleep 2
if ! ps -p $PF2_PID > /dev/null; then
  echo "❌ Failed to start port-forward for app2-svc. See app2-port-forward.log"
else
  echo "✔ app2-svc -> http://localhost:8082 (PID=$PF2_PID)"
fi

echo ""
echo "Press Ctrl+C to stop port forwarding."

# החזקה של התהליך עד Ctrl+C
wait
