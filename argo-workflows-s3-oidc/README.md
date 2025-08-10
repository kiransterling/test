# Argo Workflows with S3 and OIDC

This Helm chart simplifies the deployment of [Argo Workflows](https://argoproj.github.io/argo-workflows/) with S3 for log and artifact storage, and OIDC for authentication. It uses the official [argo-workflows](https://github.com/argoproj/argo-helm/tree/main/charts/argo-workflows) Helm chart as a dependency and exposes a simplified configuration for S3 and OIDC.

## Prerequisites

*   A Kubernetes cluster (v1.21+)
*   [Helm](https://helm.sh/) (v3+)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Installing the Chart

1.  Clone this repository.
2.  Update the `argo-workflows-s3-oidc/values.yaml` file with your S3 and OIDC configuration. See the [Configuration](#configuration) section for more details.
3.  Run the `install.sh` script:

    ```bash
    ./install.sh
    ```

This will install Argo Workflows in the `argo` namespace.

## Uninstalling the Chart

To uninstall the chart, run the `uninstall.sh` script:

```bash
./uninstall.sh
```

This will remove all the resources created by the chart, including the `argo` namespace.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `s3.createSecret` | Create a new secret for S3 credentials. | `true` |
| `s3.secretName` | The name of the secret containing S3 credentials. | `argo-s3-creds` |
| `s3.accessKey` | The access key for S3. | `""` |
| `s3.secretKey` | The secret key for S3. | `""` |
| `oidc.createSecret` | Create a new secret for OIDC credentials. | `true` |
| `oidc.secretName` | The name of the secret containing OIDC credentials. | `argo-oidc-creds` |
| `oidc.clientId` | The OIDC client ID. | `""` |
| `oidc.clientSecret` | The OIDC client secret. | `""` |
| `argo-workflows.server.sso.issuer` | The OIDC issuer URL. | `""` |
| `argo-workflows.server.sso.redirectUrl` | The OIDC redirect URL. | `""` |
| `argo-workflows.artifactRepository.s3.bucket` | The S3 bucket name. | `""` |
| `argo-workflows.artifactRepository.s3.endpoint` | The S3 endpoint. | `""` |
| `argo-workflows.artifactRepository.s3.region` | The S3 region. | `""` |

### S3 Configuration

To enable S3 for log and artifact storage, you need to provide the S3 bucket details and credentials.

If you want the chart to create a new secret for the S3 credentials, set `s3.createSecret` to `true` and provide the `s3.accessKey` and `s3.secretKey`.

If you already have a secret with the S3 credentials, set `s3.createSecret` to `false` and provide the name of the secret in `argo-workflows.artifactRepository.s3.accessKeySecret.name` and `argo-workflows.artifactRepository.s3.secretKeySecret.name`.

### OIDC Configuration

To enable OIDC for authentication, you need to provide the OIDC provider's details.

If you want the chart to create a new secret for the OIDC credentials, set `oidc.createSecret` to `true` and provide the `oidc.clientId` and `oidc.clientSecret`.

If you already have a secret with the OIDC credentials, set `oidc.createSecret` to `false` and provide the name of the secret in `argo-workflows.server.sso.clientId.name` and `argo-workflows.server.sso.clientSecret.name`.

#### Azure AD

*   **issuer**: `https://login.microsoftonline.com/<tenant-id>/v2.0`
*   **clientId**: The Application (client) ID of your Azure AD application registration.
*   **clientSecret**: The client secret of your Azure AD application registration.
*   **redirectUrl**: `https://<your-argo-ui-url>/oauth2/callback`

#### SAP BTP XSUAA

*   **issuer**: The `url` from the `VCAP_SERVICES` environment variable of your XSUAA service instance on Cloud Foundry. It should be in the format `https://<subdomain>.authentication.<region>.hana.ondemand.com`.
*   **clientId**: The `clientid` from the `VCAP_SERVICES` environment variable.
*   **clientSecret**: The `clientsecret` from the `VCAP_SERVICES` environment variable.
*   **redirectUrl**: `https://<your-argo-ui-url>/oauth2/callback`

## Accessing the Argo Workflows UI

After the installation is complete, you can access the Argo Workflows UI by port-forwarding the service:

```bash
kubectl -n argo port-forward svc/argo-workflows-server 2746:2746
```

Then open `http://localhost:2746` in your browser. You will be redirected to your OIDC provider for authentication.
