#!/bin/bash

curl -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
    "https://api.digitalocean.com/v2/kubernetes/clusters/$KUBERNETES_CLUSTER/kubeconfig" > .kubeconfig

kubectl --kubeconfig ./.kubeconfig patch deployment github-actions-test-deployment \
    -p"{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"github-actions-test\",\"image\":\"sekl/github-actions-test:$IMAGE_SHA\"}]}}}}"

kubectl --kubeconfig ./.kubeconfig rollout status deployment.v1.apps/github-actions-test-deployment

rm ./.kubeconfig