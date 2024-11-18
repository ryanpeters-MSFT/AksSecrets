# 3 - Secrets (Volume)

This step updates our `secertapi` deployment to mount the secret keys/values as files inside of the pod, instead of as environment variables. 

The main benefit of this approach is that pods don't need to be restarted when the value for a secret has changed. Previously, when the value of a secret, exposed as an environment variable, has changed, the pods must be restarted. 

## Running the Step

Deploy the updated `deployment.yaml` and `secret.yaml`. 

```powershell
# update the deployment
kubectl apply -f .\deployment.yaml
```

Navigate to the IP address and view the output. The value returned has now changed to be the value of the secret. Also, you may view the application logs to determine if the application is loading the secret using an environment variable or from a file. 