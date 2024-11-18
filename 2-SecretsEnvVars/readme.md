# 2 - Secrets (Environment Variables)

This step updates our `secertapi` deployment to retrieve the environment variable from a secret named "appsecrets" instead of storing it directly in the deployment manifest.

Kubernetes Secrets provide a secure way to store and manage sensitive data like passwords, API keys, or certificates needed by an application. By integrating Secrets with pods and restricting access via RBAC, applications can retrieve sensitive information dynamically without hardcoding it into their code or configuration files, reducing the risk of exposure.

**Values in secrets are stored as base64-encoded strings and there is no encryption enabled (by default) at rest. Azure does encrypt `etcd` by default using AES-256 encryption at the disk-layer. Support for using a [KMS](https://learn.microsoft.com/en-us/azure/aks/use-kms-etcd-encryption) with custom keys (leveraging Key Vault) is available.**

## Running the Step

Deploy the updated `deployment.yaml` and `secret.yaml`. 

```powershell
# update the deployment and create the secret
kubectl apply -f .\deployment.yaml -f .\secret.yaml
```

Navigate to the IP address and view the output. The value returned has now changed to be the value of the secret.