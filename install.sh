#!/bin/bash

# This script installs the argo-workflows-s3-oidc Helm chart.

# Exit immediately if a command exits with a non-zero status.
set -e

# The namespace to install the chart into.
NAMESPACE="argo"

# The release name for the Helm chart.
RELEASE_NAME="argo-workflows"

# The path to the values file.
VALUES_FILE="argo-workflows-s3-oidc/values.yaml"

# Create the namespace if it doesn't exist.
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Update Helm dependencies.
echo "Updating Helm dependencies..."
helm dependency build argo-workflows-s3-oidc

# Install the Helm chart.
echo "Installing the Helm chart..."
helm install "${RELEASE_NAME}" argo-workflows-s3-oidc --namespace "${NAMESPACE}" --values "${VALUES_FILE}"

echo "Argo Workflows has been installed successfully."
echo "To access the UI, run the following command:"
echo "kubectl -n ${NAMESPACE} port-forward svc/${RELEASE_NAME}-argo-workflows-server 2746:2746"
echo "Then open http://localhost:2746 in your browser."
