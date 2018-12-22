#!/bin/bash

echo "Starting rollout…"

curl -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
    "https://api.digitalocean.com/v2/kubernetes/clusters/$KUBERNETES_CLUSTER/kubeconfig" > .kubeconfig

SHA=$(git rev-parse --short HEAD)

kubectl --kubeconfig ./.kubeconfig patch deployment github-actions-test-deployment \
    -p"{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"github-actions-test\",\"image\":\"sekl/github-actions-test:$SHA\"}]}}}}"

kubectl --kubeconfig ./.kubeconfig rollout status deployment.v1.apps/github-actions-test-deployment

rm ./.kubeconfig