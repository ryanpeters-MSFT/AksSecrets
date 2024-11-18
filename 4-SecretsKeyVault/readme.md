# 4 - Secrets (Azure Key Vault)

Unfortunately, if RBAC is not enabled or misconfigured, this can allow any user or appliaction to gain access to the secrets and quickly decode their value. 

## Secrets Store CSI Driver for AKS

The [**Secrets Store CSI Driver**](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver) for AKS integrates Kubernetes with external secret management solutions like Azure Key Vault. It allows pods to access sensitive data (e.g., API keys, certificates) by mounting secrets directly as files, eliminating the need to store them in etcd. The driver uses the pod’s identity (Managed Identity or Service Principal) to securely fetch secrets from the external store.  

### **Benefits:**
1. **Enhanced Security**: Secrets are not stored in etcd, reducing the attack surface.  
2. **Dynamic Updates**: Secrets are updated automatically in mounted volumes when they change in the external store.  
3. **Compliance**: Aligns with regulatory requirements by centralizing secret management in solutions like Azure Key Vault.  
4. **Simplified Management**: Integrates seamlessly with Azure Key Vault for centralized key and certificate lifecycle management.  

## Running the Step

Deploy the updated `deployment.yaml` and `secretproviderclass.yaml`. 

```powershell
# deploy the secret provider class and updated deployment
kubectl apply -f .\secretproviderclass.yaml -f .\deployment.yaml
```

## Syncing to Kubernetes Secrets

It is possible to also sync the secrets from Key Vault to a Kubernetes `secret` and expose as environment variables. This process involves periodically syncing the value from Key Vault to the `secret` resource on a given interval (default is 2 minutes). In addition, after this is synced, pods would also need to be restarted due to updated environment variables. 

Here is an example of our `SecretProviderClass` managing and syncing a set of Key Vault secrets to a Kubernetes `secret` resource:

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-sync
spec:
  provider: azure
  secretObjects:                                  # [OPTIONAL] SecretObject defines the desired state of synced K8s secret objects
    - secretName: foosecret
      type: Opaque
      labels:
        environment: "test"
      data:
        - objectName: secretalias                 # name of the mounted content to sync. this could be the object name or object alias. The mount is mandatory for the content to be synced as Kubernetes secret.
          key: username
  parameters:
    usePodIdentity: "false"                       # [OPTIONAL] if not provided, will default to "false"
    keyvaultName: "kvname"                        # the name of the KeyVault
    objects: |
      array:
        - |
          objectName: $SECRET_NAME
          objectType: secret                      # object types: secret, key or cert
          objectAlias: secretalias
          objectVersion: $SECRET_VERSION          # [OPTIONAL] object versions, default to latest if empty
        - |
          objectName: $KEY_NAME
          objectType: key
          objectVersion: $KEY_VERSION
    tenantId: "tid"                               # the tenant ID of the KeyVault
```