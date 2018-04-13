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

echo "Removing environment \"$CI_ENVIRONMENT_SLUG\""
kubectl delete all,ing -l "app=${CI_ENVIRONMENT_SLUG}" -n "$KUBE_NAMESPACE"
