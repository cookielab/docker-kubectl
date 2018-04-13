#!/bin/bash

set -eo pipefail

if [[ -z "$KUBE_NAMESPACE" ]]; then
  echo "Missing KUBE_NAMESPACE."
  exit 1
fi

if [[ -z "$CI_COMMIT_REF_SLUG" ]]; then
  echo "Missing CI_COMMIT_REF_SLUG."
  exit 1
fi

if [[ -z "$CI_ENVIRONMENT_SLUG" ]]; then
  echo "Missing CI_ENVIRONMENT_SLUG."
  exit 1
fi

if [[ -z "$CI_ENVIRONMENT_URL" ]]; then
  echo "Missing CI_ENVIRONMENT_URL."
  exit 1
fi

if [[ -z "$KUBE_RESOURCE_NAME" ]]; then
  export KUBE_RESOURCE_NAME="$CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG"
fi

if [[ -z "$KUBE_TRACK" ]]; then
  export KUBE_TRACK="blue"
fi

if [[ -z "$KUBE_CONTAINER_PORT" ]]; then
  export KUBE_CONTAINER_PORT=3000
fi

if [[ -z "$KUBE_SERVICE_PORT" ]]; then
  export KUBE_SERVICE_PORT=3000
fi

export CI_ENVIRONMENT_HOSTNAME="${CI_ENVIRONMENT_URL/https:\/\//}"

echo "Setting up ingress"

cat <<EOF | kubectl apply -n $KUBE_NAMESPACE --force -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: $KUBE_RESOURCE_NAME
  namespace: $KUBE_NAMESPACE
  labels:
    app: "$CI_ENVIRONMENT_SLUG"
    stage: "$CI_ENVIRONMENT_SLUG"
    pipeline_id: "$CI_PIPELINE_ID"
    job_id: "$CI_JOB_ID"
spec:
  rules:
  - host: $CI_ENVIRONMENT_HOSTNAME
    http:
      paths:
      - path: /
        backend:
          serviceName: $KUBE_RESOURCE_NAME
          servicePort: $KUBE_SERVICE_PORT
EOF
