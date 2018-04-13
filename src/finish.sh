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

if [[ -z "$KUBE_TRACK" ]]; then
  export KUBE_TRACK="blue"
fi

if [[ "$KUBE_TRACK" == "blue" ]]; then
  echo "Removing canary deployments (if found)..."
  kubectl delete all,ing -l "app=$CI_ENVIRONMENT_SLUG" -l "track=canary" -n "$KUBE_NAMESPACE"
fi

echo ""
if [[ -n "$CI_ENVIRONMENT_URL" ]]; then
  echo -e "\e[32mApplication is accessible at: \e[0m\e[4m${CI_ENVIRONMENT_URL}\e[0m"
fi
echo ""
