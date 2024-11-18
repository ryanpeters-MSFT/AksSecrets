# 3 - Secrets (Volume)

This step updates our `secertapi` deployment to mount the secret keys/values as files inside of the pod, instead of as environment variables. 

The main benefit of this approach is that pods don't need to be restarted when the value for a secret has changed. Previously, when the value of a secret, exposed as an environment variable, has changed, the pods must be restarted. 

## Comparison to Environment Variables

| **Feature**                   | **Environment Variables**                             | **Volume Mounts**                                       |
|-------------------------------|-------------------------------------------------------|---------------------------------------------------------|
| **Access**                     | Accessed via `getenv` or environment-based config     | Accessed via mounted files in the container filesystem  |
| **Security**                   | Risk of exposure in logs or process environment       | More secure; accessible only via file system            |
| **Dynamic Updates**            | Requires pod restart for updates                     | Automatically updates with external secret changes      |
| **Best Use Case**              | Small, static secrets (e.g., API keys)                | Larger secrets, certificates, or frequently rotated secrets |
| **Exposure in Logs**           | Can be exposed in logs if not managed properly        | Not exposed unless explicitly logged                    |
| **Secret Rotation**            | Manual update and pod restart needed                  | Automatic rotation and updates without restart          |

## Running the Step

Deploy the updated `deployment.yaml`. 

```powershell
# update the deployment
kubectl apply -f .\deployment.yaml
```

Navigate to the IP address and view the output. The value returned has now changed to be the value of the secret. Also, you may view the application logs to determine if the application is loading the secret using an environment variable or from a file. 