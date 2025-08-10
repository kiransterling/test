#!/bin/bash

# This script uninstalls the argo-workflows-s3-oidc Helm chart.

# Exit immediately if a command exits with a non-zero status.
set -e

# The namespace where the chart is installed.
NAMESPACE="argo"

# The release name for the Helm chart.
RELEASE_NAME="argo-workflows"

# Uninstall the Helm chart.
echo "Uninstalling the Helm chart..."
helm uninstall "${RELEASE_NAME}" --namespace "${NAMESPACE}"

# Delete the namespace.
echo "Deleting the namespace..."
kubectl delete namespace "${NAMESPACE}"

echo "Argo Workflows has been uninstalled successfully."
