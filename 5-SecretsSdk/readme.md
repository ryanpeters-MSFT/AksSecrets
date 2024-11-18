# 5 - Secrets (Azure Key Vault with SDK)

*Note: this step requires that an identity is assigned to the VMSS nodes or workload identity has been enabled. This example uses workload identity as it provides more granular control over the identity/account that is used by a specific application.*

Instead of exposing secrets from Key Vault using environment variables or volume mounts, we can leverage the [Azure Key Vault SDK](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/key-vault?view=azure-dotnet) to access the vault. In addition, when a managed identity (system-assigned or user-assigned) is enabled at an assigned to the VMSS, or to the workload as per workload identity, these secret values can be accessed without managing a single password. 

Instead, it relies on the `DefaultCredential` type to retrieve the necessary keys (stored within the pod) to access the key vault resource. From there, the secrets can be retrieved directly from the application process.

## Running the Step

1. Navigate to our [app](../1-App/) folder and run the following commands to add the SDK NuGet packages:

```powershell
dotnet add package Azure.Identity
dotnet add package Azure.Security.KeyVault.Secrets
```

2. Replace the contents of [Program.cs](../1-App/Program.cs) with the contents of this folder's [Program.cs](./Program.cs). This change references the Key Vault public URL using the SDK and retrieves the key. 

3. Run the initial [deploy.ps1](../1-App/deploy.ps1) script to re-build and push to the ACR. 
4. Invoke `kubectl rollout restart deploy secretapi` to restart the deployment and download the updated image.