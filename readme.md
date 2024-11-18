# AKS Secrets Demo

This repository provides a demonstration of various ways to use Kubernetes secrets in applications. In addition, Azure Key Vault can be used to provide secure access secrets using [Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview?tabs=dotnet). 

## Running The Demos

Proceed to each section and complete the setup steps:

- [0 - AKS Deployment](./0-AKS/) - Configure our AKS cluster and necesary dependencies.
- [1 - Application Deployment](./1-App/) - Deploy our test .NET Web API application.
- [2 - Secrets (Environment Variables)](./2-SecretsEnvVars/) - Expose secrets via environment variables.
- [3 - Secrets (Volume)](./3-SecretsVolume/) - Expose secrets via a volume mount.
- [4 - Secrets (Azure Key Vault)](./4-SecretsKeyVault/) - Retrieve secrets from Azure Key Vault and expose via a volume mount.
- [5 - Secrets (Azure Key Vault with SDK)](./5-SecretsSdk/) - Leverage the Key Vault SDK to retrieve secrets from within the applicaton.