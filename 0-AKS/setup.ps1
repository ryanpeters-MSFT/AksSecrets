$group = "rg-aks-secrets"
$cluster = "secretscluster"
$keyVaultName = "secretsvaultrjp"
$acr = "secretsdemoacr"
$namespace = "default" # kubernetes namespace of the service account
$serviceAccountName = "cluster-workload-user" # kubernetes service account name
$federatedName = "federated-workload-user" # id used for federated credential
$azureManagedIdentity = "ryan-workload" # workload managed identity in Azure

# create resource group
az group create -n $group -l eastus2

# create a container registry
az acr create -n $acr -g $group --sku Standard

# log into the ACR
az acr login -n $acr

# create a cluster
az aks create -n $cluster -g $group `
    -c 1 `
    --attach-acr $acr `
    --enable-oidc-issuer `
    --enable-workload-identity `
    --enable-addons azure-keyvault-secrets-provider

# authenticate to the cluster
az aks get-credentials -n $cluster -g $group --overwrite-existing

# get OIDC issuer
$oidcIssuer = az aks show -n $cluster -g $group --query oidcIssuerProfile.issuerUrl -o tsv

# create the azure managed identity for the control plane
$userAssignedClientId  = az identity create -n $azureManagedIdentity -g $group --query clientId -o tsv

# create the federated identity
az identity federated-credential create -g $group `
    --name $federatedName `
    --identity-name $azureManagedIdentity `
    --issuer $oidcIssuer `
    --subject system:serviceaccount:$($namespace):$($serviceAccountName) `
    --audience api://AzureADTokenExchange

# create the key vault
az keyvault create -n $keyVaultName -g $group

# get current user ID
$subscription = az account show --query id -o tsv
$userId = az ad signed-in-user show -o tsv --query id

# assign the correct role to my user (me) to allow KV access (00482a5a-887f-4fb3-b363-3b7fe8e74483 = Key Vault Administrator)
az role assignment create `
    --role 00482a5a-887f-4fb3-b363-3b7fe8e74483 `
    --assignee $userId `
    --scope /subscriptions/$subscription/resourceGroups/$group/providers/Microsoft.KeyVault/vaults/$keyVaultName

# assign the correct role to the UAMI to allow KV access (4633458b-17de-408a-b874-0445c86b69e6 = Key Vault Secrets User)
az role assignment create `
    --role 4633458b-17de-408a-b874-0445c86b69e6 `
    --assignee $userAssignedClientId `
    --scope /subscriptions/$subscription/resourceGroups/$group/providers/Microsoft.KeyVault/vaults/$keyVaultName

# sleep to allow propagate
Start-Sleep -Seconds 10

# set a key vault secret
az keyvault secret set --name mysecretvalue --vault-name $keyVaultName --value "my super secret value from key vault!"

"Set this client ID as the azure.workload.identity/client-id annotation for the service account: $($userAssignedClientId)"