#!/bin/bash

set -eo pipefail

if [[ -z "$KUBE_NAMESPACE" ]]; then
  echo "Missing KUBE_NAMESPACE."
  exit 1
fi

if [[ -z "$CI_ENVIRONMENT_SLUG" ]]; then
  echo "Missing CI_ENVIRONMENT_SLUG."
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

echo "Setting up service for track($KUBE_TRACK)"

cat <<EOF | kubectl apply -n $KUBE_NAMESPACE --force -f -
apiVersion: v1
kind: Service
metadata:
  name: $KUBE_RESOURCE_NAME
  namespace: $KUBE_NAMESPACE
  labels:
    app: "$CI_ENVIRONMENT_SLUG"
    stage: "$CI_ENVIRONMENT_SLUG"
    pipeline_id: "$CI_PIPELINE_ID"
    job_id: "$CI_JOB_ID"
spec:
  ports:
    - protocol: TCP
      port: $KUBE_SERVICE_PORT
      targetPort: $KUBE_CONTAINER_PORT
  selector:
    app: $CI_ENVIRONMENT_SLUG
    type: server
EOF
