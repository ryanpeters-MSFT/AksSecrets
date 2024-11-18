# 0 - AKS Deployment

This step invokes several steps to create and configure the AKS cluster as well as supporting resources, such as:

1. Resource Group
2. [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro)
3. [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/what-is-aks) (with workload identity enabled)
4. [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
5. Necessary role assignments using User-Assigned Managed Identies

## Running the Step

1. Invoke the file `setup.ps1` to create the cluster, key vault, ACR, and necessary roles. This will also create a secret named "mysecretvalue" in our Azure Key Vault.
2. Once `setup.ps1` completes, it will output the Client ID used for our application to use (via a service account and OIDC issuer). **Note the value of this client ID** and set this as the value for the annotation `azure.workload.identity/client-id` in `serviceaccount.yaml`.
3. Finally, run `deploy.ps1` to apply this service account as well as the deployment for our application and the service. 

This step creates an initial cluster with a basic deployment for our application, to be deployed in [the next step](../1-App/).

**Note that the deployment will fail, with the error `ImagePullBackOff` until the image is uploaded in the next step. This is because the ACR is created in this step, which is required for the next step.**