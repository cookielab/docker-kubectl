#!/bin/bash

set -eo pipefail

if [[ -z "$KUBE_URL" ]]; then
  echo "Missing KUBE_URL."
  exit 1
fi

if [[ -z "$KUBE_CA_PEM_FILE" ]]; then
  echo "Missing KUBE_CA_PEM_FILE."
  exit 1
fi

if [[ -z "$KUBE_TOKEN" ]]; then
  echo "Missing KUBE_TOKEN."
  exit 1
fi

if [[ -z "$KUBE_NAMESPACE" ]]; then
  echo "Missing KUBE_NAMESPACE."
  exit 1
fi

echo "Connecting to Kubernetes cluster"

kubectl config set-cluster default-cluster --server=$KUBE_URL --certificate-authority="$KUBE_CA_PEM_FILE"
kubectl config set-credentials default-admin --token=$KUBE_TOKEN
kubectl config set-context default-system --cluster=default-cluster --user=default-admin --namespace $KUBE_NAMESPACE
kubectl config use-context default-system
kubectl cluster-info
