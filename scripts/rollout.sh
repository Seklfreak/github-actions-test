#!/bin/bash

CONTAINER_NAME="github-actions-test"
DEPLOYMENT_NAME="$CONTAINER_NAME-deployment"
IMAGE_NAME="sekl/github-actions-test"

TMP_KUBECONFIG=".kubeconfig"

API_ENDPOINT_KUBECONFIG="https://api.digitalocean.com/v2/kubernetes/clusters/$DIGITALOCEAN_K8S_CLUSTER_ID/kubeconfig"

# get current version
SHA=$(git rev-parse --short HEAD)

# get kubeconfig
curl -s -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
    ${API_ENDPOINT_KUBECONFIG} > ${TMP_KUBECONFIG}

kubectl --kubeconfig ${TMP_KUBECONFIG} patch deployment ${DEPLOYMENT_NAME} \
    -p"{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"$CONTAINER_NAME\",\"image\":\"$IMAGE_NAME:$SHA\"}]}}}}"

# wait for rollout to finish
kubectl --kubeconfig ${TMP_KUBECONFIG} rollout status deployment.v1.apps/${DEPLOYMENT_NAME}

# delete kubeconfig
rm ${TMP_KUBECONFIG}