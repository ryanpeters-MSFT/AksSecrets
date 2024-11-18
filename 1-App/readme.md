# 1 - Application Deployment

This step compiles the application using Docker and pushes the image to our Azure Container Registry. The application is a simple .NET Web API that retrieves a secret value from a Kubernetes `secret` named "apikey" and returns its value in the response. 

```powershell
# curl the IP
curl http://API-SERVICE-IP/

# returns
"this is a hard-coded secret in my deployment. yuck!!"
```

**Obviously this would never happen in a real-world scenario**, but for the intent is to show how to access the value. 

## Running the Step

1. Install [Docker](https://docs.docker.com/engine/install/) on your machine. *There is no need to install the .NET SDK*.
2. Run `deploy.ps1` to build the image using our `Dockerfile` and push to our container registry.

Once the image has been pushed, you may need to invoke `kubectl rollout restart deploy secretapi` to force an image update (if it has not already reconciled the image).